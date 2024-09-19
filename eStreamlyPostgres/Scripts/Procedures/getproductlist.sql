CREATE OR REPLACE FUNCTION public.getproductlist(
	productid bigint,
	ref1 refcursor,
	ref2 refcursor,
	ref3 refcursor,
	ref4 refcursor,
	ref5 refcursor,
	ref6 refcursor,
	ref7 refcursor,
	ref8 refcursor,
	ref9 refcursor,
	ref10 refcursor,
	ref11 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE businessId numeric :=(select p."Business_Id"
from "Product" p
where p."Product_Id" = productId);

DECLARE productCategoryId numeric :=(select "Product_Category_Id"
from "Product" p
where p."Product_Id" = productId);

BEGIN

DROP TABLE IF EXISTS discountOffer;
CREATE TEMP TABLE discountOffer AS
select *
	  ,ROW_NUMBER() over(partition by dof."Product_Id" order by dof."Created_Date" desc) rn
from "Discount_Offer" dof
where dof."Business_Id" = businessId
and NOW()  between "Valid_Start_Date" and "Valid_End_Date";

DROP TABLE IF EXISTS coupon;
CREATE TEMP TABLE coupon AS
select * 
from "Discount_Coupon" dc
where "Business_Id" = businessId
--and GETDATE() between Valid_Start_Date and Valid_End_Date\
and ( NOW()  between "Valid_Start_Date" and "Valid_End_Date");
 
DROP TABLE IF EXISTS productList;
CREATE TEMP TABLE productList AS
select P.BusinessId "BusinessId"
	  ,P."Price"
	  ,P.ProductDescription "ProductDescription"
	  ,P.ProductName "ProductName"
	  ,P.ProductId "ProductId"
	  ,P.ProductVideoId "ProductVideoId"
	  ,P.ProductImage "ProductImage"
	  ,P.BusinessImage "BusinessImage"
	  ,P.BusinessBackgroundImage "BusinessBackgroundImage"
	  ,P.BusinessName "BusinessName"
	  ,P.BusinessShortName "BusinessShortName"
	  ,P.ProductVariantListId "ProductVariantListId"
	  ,P.ProductVariantKey "ProductVariantKey"
	  ,P.ProductVariantValue "ProductVariantValue"
	  ,COALESCE(P.DiscountedPrice,P."Price") "DiscountedPrice"
	  ,P.IsDiscountAvailable "IsDiscountAvailable"
	  ,P.DiscountPercentage "DiscountPercentage"
	  ,P."Note"
	  ,P."Position"
	  ,P.ProductCategory "ProductCategory"
	  ,P.IsCouponAvailable "IsCouponAvailable"
	  ,p."ECommercePlatform"
	  ,p."StripeConnectAccountId" 
	  ,p."Product_Category_Id"
from (
select p."Business_Id" BusinessId
	    ,p."Product_Description" ProductDescription
	    ,p."Product_Name" ProductName 
	    ,p."Product_Id" ProductId
	    ,CASE WHEN p."Product_Id" is null OR p."productvid" = '' THEN pvi."Video_Url" ELSE p."productvid" END ProductVideoId
	    ,pi."Image_Url" ProductImage
		,b."Business_Image" BusinessImage
		,b."Background_Image" BusinessBackgroundImage
		,b."Business_Name" BusinessName
		,b."Shortname" BusinessShortName
		,pvl."Product_Variant_List_Id" ProductVariantListId
	    ,'' ProductVariantKey
		,pvl."Title" ProductVariantValue
		,pv1."Product_Variant_List" ProductVariantValue1
		,case when pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 then pvl."CompareAtPrice" else pvl."Price"  End "Price"
		,ROW_NUMBER() OVER (PARTITION BY p."Product_Id",pvl."Product_Variant_List_Id" ORDER BY pi."Created_Date" ) AS rn
		,case when pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 and  pvl."CompareAtPrice" != pvl."Price" then pvl."Price" else COALESCE(cast (pvl."Price"  - (pvl."Price"  * dof."Discount_Percentage" / 100) as decimal(10,2)),pvl."Price") end DiscountedPrice
		,CASE WHEN ( pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 and  pvl."CompareAtPrice" != pvl."Price" ) or  dof."Discount_Percentage" > 0 THEN 1 ELSE 0 END :: bit IsDiscountAvailable
		,dof."Discount_Percentage" DiscountPercentage
		,p."Note"
		,pvl."Position"
		,pc."Name" ProductCategory
		,CASE WHEN c."Discount_Percentage" > 0 THEN 1 ELSE 0 END IsCouponAvailable
	   ,b."Order_Management_Sytem" "ECommercePlatform"
	   ,b."Stripe_Connect_Account_Id" "StripeConnectAccountId"
	   ,p."Product_Category_Id"
from "Product" p 
join "Business" b on p."Business_Id" = b."Business_Id"
join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
left join "Product_Variant" pv on pvl."Product_Variant1_Id" = pv."Product_Variant_Id"
left join "Product_Variant" pv1 on pvl."Product_Variant2_Id" = pv1."Product_Variant_Id"
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join "Product_Video" pvi on p."Product_Id" = pvi."Product_Id"
left join discountOffer dof on b."Business_Id" = dof."Business_Id" and (dof."Product_Id" is null or dof."Product_Id" = p."Product_Id")  and (dof."rn" is null or dof."rn" = 1)
left join "Product_Category" pc on p."Product_Category_Id" = pc."Product_Category_Id"
left join coupon c on b."Business_Id" = c."Business_Id" 
						and (c."Product_Id" is null or c."Product_Id" = p."Product_Id")
where b."Business_Id" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null) and p."Status" = 'active'and  pvl."Status" = 'active' 
and p."Product_Id" = productId) p
where "rn" = 1
ORDER BY p.ProductId,p."Position";

insert into productList
select P.BusinessId "BusinessId"
	  ,P."Price"
	  ,P.ProductDescription "ProductDescription"
	  ,P.ProductName "ProductName"
	  ,P.ProductId "ProductId"
	  ,P.ProductVideoId "ProductVideoId"
	  ,P.ProductImage "ProductImage"
	  ,P.BusinessImage "BusinessImage"
	  ,P.BusinessBackgroundImage "BusinessBackgroundImage"
	  ,P.BusinessName "BusinessName"
	  ,P.BusinessShortName "BusinessShortName"
	  ,P.ProductVariantListId "ProductVariantListId"
	  ,P.ProductVariantKey "ProductVariantKey"
	  ,P.ProductVariantValue "ProductVariantValue"
	  ,COALESCE(P.DiscountedPrice,P."Price") "DiscountedPrice"
	  ,P.IsDiscountAvailable "IsDiscountAvailable"
	  ,P.DiscountPercentage "DiscountPercentage"
	  ,P."Note"
	  ,P."Position"
	  ,P.ProductCategory "ProductCategory"
	  ,P.IsCouponAvailable "IsCouponAvailable"
	  ,p."ECommercePlatform"
	  ,p."StripeConnectAccountId"
	   ,p."Product_Category_Id"
from (
select p."Business_Id" BusinessId
	    ,p."Product_Description" ProductDescription
	    ,p."Product_Name" ProductName 
	    ,p."Product_Id" ProductId
	    ,CASE WHEN p."Product_Id" is null OR p."productvid" = '' THEN pvi."Video_Url" ELSE p."productvid" END ProductVideoId
	    ,pi."Image_Url" ProductImage
		,b."Business_Image" BusinessImage
		,b."Background_Image" BusinessBackgroundImage
		,b."Business_Name" BusinessName
		,b."Shortname" BusinessShortName
		,pvl."Product_Variant_List_Id" ProductVariantListId
	    ,'' ProductVariantKey
		,pvl."Title" ProductVariantValue
		,pv1."Product_Variant_List" ProductVariantValue1
		,case when pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 then pvl."CompareAtPrice" else pvl."Price"  End "Price"
		,ROW_NUMBER() OVER (PARTITION BY p."Product_Id",pvl."Product_Variant_List_Id" ORDER BY pi."Created_Date" ) AS rn
		,case when pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 and  pvl."CompareAtPrice" != pvl."Price" then pvl."Price" else COALESCE(cast (pvl."Price"  - (pvl."Price"  * dof."Discount_Percentage" / 100) as decimal(10,2)),pvl."Price") end DiscountedPrice
		,CASE WHEN ( pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 and  pvl."CompareAtPrice" != pvl."Price" ) or  dof."Discount_Percentage" > 0 THEN 1 ELSE 0 END :: bit IsDiscountAvailable
		,dof."Discount_Percentage" DiscountPercentage
		,p."Note"
		,pvl."Position"
		,pc."Name" ProductCategory
		,CASE WHEN c."Discount_Percentage" > 0 THEN 1 ELSE 0 END IsCouponAvailable
	   ,b."Order_Management_Sytem" "ECommercePlatform"
	   ,b."Stripe_Connect_Account_Id" "StripeConnectAccountId"
	   ,p."Product_Category_Id"
from "Product" p 
join "Business" b on p."Business_Id" = b."Business_Id"
join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
left join "Product_Variant" pv on pvl."Product_Variant1_Id" = pv."Product_Variant_Id"
left join "Product_Variant" pv1 on pvl."Product_Variant2_Id" = pv1."Product_Variant_Id"
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join "Product_Video" pvi on p."Product_Id" = pvi."Product_Id"
left join discountOffer dof on b."Business_Id" = dof."Business_Id" and (dof."Product_Id" is null or dof."Product_Id" = p."Product_Id")  and (dof."rn" is null or dof."rn" = 1)
left join "Product_Category" pc on p."Product_Category_Id" = pc."Product_Category_Id"
left join coupon c on b."Business_Id" = c."Business_Id" 
						and (c."Product_Id" is null or c."Product_Id" = p."Product_Id")
where b."Business_Id" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null) and p."Status" = 'active'and  pvl."Status" = 'active'
and (p."Product_Id" in (select p."Product_Id" from "Product" p where  p."Status" = 'active' and p."Business_Id" = businessId limit 60))
and p."Product_Id" != productId) p
where "rn" = 1
ORDER BY p.ProductId,p."Position";

OPEN ref1 FOR   
select * 
from productList;
    RETURN NEXT ref1;
	
    OPEN ref2 FOR select pd."Product_Id" ProductId
      ,pd."Description"
	  ,pd."Name"
	  ,pd."Product_Detail_Id"
from productList p
join "Product_Detail" pd on p."ProductId" = pd."Product_Id"
where p."BusinessId" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null);
    RETURN NEXT ref2;
	
	OPEN ref3 FOR
	select * from 
(select pr."Product_Id" ProductId
	  ,'' ReviewTitle
      ,pr."Review_Detail"  ReviewDetail
	  ,pr."Review_Rating" ReviewRating
	  ,pr."UserId"
	  ,COALESCE(u."UserName","User_Name") UserName
	  ,COALESCE(u."ImageUrl",'') User_Profile_Image
	  ,0 BusinessId
from productList p
join "Product_Review" pr on p."ProductId" = pr."Product_Id"
left join "AspNetUsers" u on pr."UserId" = u."Id"
where p."BusinessId" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null) 

UNION 

select 0 ProductId
	  ,"Review_Title" ReviewTitle
	  ,cast("Review_Detail" as varchar) ReviewDetail
	  ,"Review_Rating" ReviewRating
	  ,'' UserId
	  ,"User_Name" UserName
	  ,'' User_Profile_Image
	  ,"Business_Id" BusinessId
from "Business_Review"
where "Business_Id" =businessId) review;
RETURN NEXT ref3;

OPEN ref4 FOR
select pi."Product_Id" ProductId
      ,pi."Image_Url" ProductImage
	  ,pi."Product_Image_Id" ProductImageId
	  ,pi."Desktop_Image_Url" DesktopImageUrl
	  ,pi."Mobile_Image_Url" MobileImageUrl
	  ,pi."Tablet_Image_Url" TabletImageUrl
from productList p
join "Product_Image" pi on p."ProductId" = pi."Product_Id"
where p."BusinessId" = businessId
and (pi."Is_Active" is null or pi."Is_Active" = true)
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null);
	RETURN NEXT ref4;
	
	OPEN ref5 FOR
	select pd."Product_Id" ProductId
      ,pd."Answer"
	  ,pd."Product_Ques_Ans_Id" ProductQuesAnsId
	  ,pd."QuesPostedUserId" QuesPostedUserId
	  ,pd."Question" 
	  ,u."UserName"
from productList p
join "Product_Ques_Ans" pd on p."ProductId" = pd."Product_Id"
join "AspNetUsers" u on pd."QuesPostedUserId" = u."Id"
where p."BusinessId" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null);
RETURN NEXT ref5;

OPEN ref6 FOR
select p."ProductId" ProductId
      ,pd."Product_Shipping_Id" ProductShippingDetailId
	  ,pd."Return_Detail" ReturnDetail
	  ,pd."Shipping_Detail" ShippingDetail
	  ,CASE WHEN (pd."Max_Order_Amount" > 0 and pd."Max_Order_Amount" < 100000  ) and pd."Shipping_Amount" > 0 THEN 'Free US standard shipping for orders valued at $'|| cast(pd."Max_Order_Amount" as varchar(50))||' or more </br> $' || cast(pd."Shipping_Amount" as varchar(50))||' Standard Flat Rate Shipping' 
		WHEN (pd."Max_Order_Amount" > 0 and pd."Max_Order_Amount" < 100000  ) THEN 'Free US standard shipping for orders valued at $'|| cast(pd."Max_Order_Amount" as varchar(50))||' or more </br>' 
		WHEN pd."Shipping_Amount" > 0 THEN '$' || cast(pd."Shipping_Amount" as varchar(50))||' Standard Flat Rate Shipping' 
		WHEN pd."Shipping_Amount" = 0 AND  pd."Max_Order_Amount" = 0 THEN 'FREE Shipping on all orders'
	  ELSE '' 
	  END ShippingSummary
from productList p
join "Product_Shipping_Detail" pd on p."BusinessId" = pd."Business_Id"
where p."BusinessId" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null);
	RETURN NEXT ref6;
	
	OPEN ref7 FOR
	select pd."Product_Id" ProductId
      ,pd."Price" Amount
	  ,pd."Interval" 
	  ,pd."Interval_Count" IntervalCount
	  ,pd."Stripe_Price_Id" StripePriceId
	  ,pd."Subscription_Name" SubscriptionName
	  ,pd."product_variant_list_Id" ProductVariantListId
from productList p
join "Subscription_Price" pd on p."ProductId" = pd."Product_Id"
join "Product_Variant_List" pvl on pd."product_variant_list_Id" = pvl."Product_Variant_List_Id"
where p."BusinessId" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null)
and pd."Is_Active" = '1';
	RETURN NEXT ref7;
	
	OPEN ref8 FOR
	select f."Business_Id" BusinessId
      ,f."Influencer_Id" InfluencerId
	  ,f."UserId"
	  ,u."UserName" 
	  ,u."ImageUrl" User_Profile_Image
	  ,u."ThumbnailImageUrl" User_Thumbnail_Image
from "Follower" f
join "AspNetUsers" u on f."UserId" = u."Id"
where f."Business_Id" = businessId;
	RETURN NEXT ref8;
	
	OPEN ref9 FOR
	select pi."Product_Id" ProductId
      ,pi."Video_Url" ProductVideo
	  ,pi."Product_Video_Id" ProductVideoId
from productList p
join "Product_Video" pi on p."ProductId" = pi."Product_Id"
where p."BusinessId" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null);
	RETURN NEXT ref9;
	
	OPEN ref10 FOR
	select "Business_Payment_Method_Id" BusinessPaymentMethodId 
	  ,"Payment_Method" PaymentMethod
	  ,"Sort_Order" sortorder
	  ,"Payment_Integration" PaymentIntegration
from "Business_Payment_Methods"
where "Business_Id" = businessId;
	RETURN NEXT ref10;
	
OPEN ref11 FOR
select pi."Product_Id" ProductId
  ,pi."Image_Url" ProductImage
  ,pi."Product_Image_Id" ProductImageId
  ,pi."Desktop_Image_Url" DesktopImageUrl
  ,pi."Mobile_Image_Url" MobileImageUrl
  ,pi."Tablet_Image_Url" TabletImageUrl
  ,pvl."Product_Variant_List_Id" "ProductVariantListId"
from productList p
join "Product_Variant_List" pvl on p."ProductId" = pvl."Product_Id"
join "Product_Variant_Image" pvi on  p."ProductId" = pvi."Product_Id" and  pvi."Product_Variant_List_Id" = pvl."Product_Variant_List_Id"
join "Product_Image" pi on pvi."Product_Image_Id" = pi."Product_Image_Id"
where p."BusinessId" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null)
order by pvi."Created_Date" desc;
RETURN NEXT ref11;
	
END;
$BODY$;
