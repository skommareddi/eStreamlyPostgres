﻿CREATE OR REPLACE FUNCTION public.getproductlistbyupcomingevent(
	upcominguniqueid character varying,
	businessid numeric,
	refcursor1 refcursor,
	refcursor2 refcursor,
	refcursor3 refcursor,
	refcursor4 refcursor,
	refcursor5 refcursor,
	refcursor6 refcursor,
	refcursor7 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

	DECLARE startDate timestamp;endDate timestamp;
	Declare shortname varchar(500);
	DECLARE shippingDetail varchar;
	productCategoryId decimal(10);
BEGIN

select "Start_Date_Time"
INTO startDate
from "Upcoming_Live_Stream"
where "Media_Unique_Id" = upcomingUniqueId;

select "End_Date_Time"
INTO endDate
from "Upcoming_Live_Stream"
where "Media_Unique_Id" = upcomingUniqueId;

select "Shortname" 
INTO shortname
from "Business" 
where "Business_Id" = businessId;

select  CASE WHEN pd."Max_Order_Amount" > 0 and pd."Shipping_Amount" > 0 THEN 'Free US standard shipping for orders valued at $'|| cast(pd."Max_Order_Amount" as varchar(50))||' or more </br> $' || cast(pd."Shipping_Amount" as varchar(50))||' Standard Flat Rate Shipping' 
							  WHEN pd."Max_Order_Amount" > 0 THEN 'Free US standard shipping for orders valued at $'|| cast(pd."Max_Order_Amount" as varchar(50))||' or more </br>' 
							  WHEN pd."Shipping_Amount" > 0 THEN '$' || cast(pd."Shipping_Amount" as varchar(50))||' Standard Flat Rate Shipping' 
							ELSE '' END
INTO shippingDetail
from "Product_Shipping_Detail" pd
where pd."Business_Id" = businessId;

DROP TABLE IF EXISTS upcomingProductList;
create temp table upcomingProductList
(
	Product_Id decimal(10),
	Created_Date timestamp
);

insert into upcomingProductList
select pi."Product_Id"
	  ,pi."Created_Date" "Created_Date"
from "Poll_Info" pi
where pi."Unique_Id" = upcomingUniqueId
and pi."Poll_Type" = 2 ;

insert into upcomingProductList
select up."Product_Id"
	  ,up."Created_Date" "Created_Date"
from "Upcoming_Live_Stream" ul
join "Upcoming_Poll_Info" up on ul."Media_Unique_Id" = up."Upcoming_Unique_Id"
where ul."Media_Unique_Id" = upcomingUniqueId
and up."Poll_Type" = 2 and "Is_Poll_Posted" = false;

insert into upcomingProductList
select vi."Product_Id"
	  ,vi."Created_Date" "Created_Date"
from "Video_Channel" vc
join "Video_Interactivity" vi on vc."Video_Channel_Id" = vi."Video_Channel_Id"
where vc."Video_Unique_Id"= upcomingUniqueId;

DROP TABLE IF EXISTS productList;
CREATE TEMP TABLE productList AS
select Product_Id
	  ,Created_Date
from (select * 
		  ,ROW_NUMBER() over(partition by Product_Id order by Created_Date desc) rn
	  from upcomingProductList ) u 
where rn = 1;

DROP TABLE IF EXISTS list;
create temp table list (
BusinessId bigint not null,
ProductDescription varchar,
ProductName varchar(250),
ProductId bigint not null,
ProductVideoId varchar(250),
ProductImage varchar,
BusinessImage varchar,
BusinessBackgroundImage varchar,
BusinessName varchar(250),
BusinessShortName varchar(250),
ProductVariantListId  bigint not null,
ProductVariantKey varchar(250),
ProductVariantValue varchar(250),
ProductVariantValue1 varchar(250),
Price decimal(10,2) not null,
rn int,
CreatedDate timestamp,
DiscountedPrice decimal(10,2) null,
IsDiscountAvailable bit,
DiscountPercentage numeric null,
ProductCategory varchar(250),
IsCouponAvailable bit,
ECommercePlatform varchar(250),
VariantName varchar(250),
StripeConnectAccountId varchar(250),
IsInventoryTrackingAvailable boolean,
InventoryTracking varchar(250),
InventoryStockLevel numeric null,
InventoryLowStockLevel numeric null,
IsOutofStock boolean,
ExternalProductId bigint null,	
ProductVariantId bigint null
);

with discountOffer as (
select *
from "Discount_Offer" d
where "Business_Id" = businessId
and NOW() between "Valid_Start_Date" and "Valid_End_Date"
), coupon as 
(
select * 
from "Discount_Coupon" dc
where "Business_Id" = businessId
--and GETDATE() between Valid_Start_Date and Valid_End_Date\
and ( NOW() between "Valid_Start_Date" and "Valid_End_Date")
)

INSERT into list
select bp."Business_Id" "BusinessId"
	    ,COALESCE(p."Short_Description",p."Product_Description") "ProductDescription"
	    ,p."Product_Name" "ProductName" 
	    ,p."Product_Id" "ProductId"
	    ,p."productvid" "ProductVideoId"
	    ,pi."Image_Url" "ProductImage"
		,b."Business_Image" "BusinessImage"
		,b."Background_Image" "BusinessBackgroundImage"
		,b."Business_Name" "BusinessName"
		,b."Shortname" "BusinessShortName"
		,pvl."Product_Variant_List_Id" "ProductVariantListId"
	    ,pvl."Title" "ProductVariantKey"
		,'' "ProductVariantValue"
		,pv1."Product_Variant_List" "ProductVariantValue1"
		,case when pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 then pvl."CompareAtPrice" else pvl."Price"  End "Price"
		,ROW_NUMBER() OVER (PARTITION BY p."Product_Id",pvl."Product_Variant_List_Id" ORDER BY pi."Created_Date",up.Created_Date desc ) AS "rn"	   
		,up.Created_Date "CreatedDate"
		,case when pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 and  pvl."CompareAtPrice" != pvl."Price" and  (d."Discount_Percentage" is null or  d."Discount_Percentage" = 0 ) then pvl."Price" else COALESCE(cast (pvl."Price"  - (pvl."Price"  * d."Discount_Percentage" / 100) as decimal(10,2)),pvl."Price") end "DiscountedPrice"
		,CASE WHEN ( pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 and  pvl."CompareAtPrice" != pvl."Price" ) or  d."Discount_Percentage" > 0 THEN 1 ELSE 0 END :: bit "IsDiscountAvailable"	
		,d."Discount_Percentage" "DiscountPercentage"
		,pc."Name" "ProductCategory"
		,CASE WHEN c."Discount_Percentage" > 0 THEN 1 ELSE 0 END :: bit "IsCouponAvailable"
		,CASE when LOWER(b."Order_Management_Sytem") = 'shopify' and bc."Config_Value" = 'Y' then 'shopify'
	   		 when LOWER(b."Order_Management_Sytem") = 'shopify' then null
	   		 else LOWER(b."Order_Management_Sytem") END "ECommercePlatform"
		,pvl."Title" "VariantName"
		,b."Stripe_Connect_Account_Id" "StripeConnectAccountId"
		,p."Is_Inventory_Tracking_Available" "IsInventoryTrackingAvailable"
        ,p."Inventory_Tracking" "InventoryTracking"
        ,CASE WHEN p."Inventory_Tracking" = 'product' THEN p."Inventory_Stock_Level"
        WHEN p."Inventory_Tracking" = 'variant' THEN pvl."Inventory_Stock_Level"
        ELSE 0
        END "InventoryStockLevel"
       , CASE WHEN p."Inventory_Tracking" = 'product' THEN p."Inventory_Low_Stock_Level"
        WHEN p."Inventory_Tracking" = 'variant' THEN pvl."Inventory_Low_Stock_Level"
        ELSE 0
        END "InventoryLowStockLevel"
        ,CASE WHEN p."Is_Inventory_Tracking_Available" = true  
        and ((p."Inventory_Tracking" = 'product' and p."Inventory_Stock_Level" = 0 )
        or (p."Inventory_Tracking" = 'variant' and pvl."Inventory_Stock_Level" = 0 ))
        THEN true
        ELSE false
        END "IsOutofStock"
		,COALESCE(p."Shopify_Product_Id",bpr."BigCommerce_Product_Id") "ExternalProductId"
		,COALESCE(pvl."Shopify_Product_Variants_Id",bpv."BigCommerce_Product_Variant_Id") "ProductVariantId"
from "Product" p 
join "Business_Product" bp on p."Product_Id" = bp."Product_id"
join "Business" b on bp."Business_Id" = b."Business_Id"
join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
left join "Product_Variant" pv on pvl."Product_Variant1_Id" = pv."Product_Variant_Id"
left join "Product_Variant" pv1 on pvl."Product_Variant2_Id" = pv1."Product_Variant_Id"
join upcomingProductList up on p."Product_Id" = up.Product_Id
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join discountOffer d on b."Business_Id" = d."Business_Id" 
						and (d."Product_Id" is null or d."Product_Id" = p."Product_Id")
left join coupon c on b."Business_Id" = c."Business_Id" 
						and (c."Product_Id" is null or c."Product_Id" = p."Product_Id")
left join "Product_Category" pc on p."Product_Category_Id" = pc."Product_Category_Id"
left join "Business_Config" bc on b."Business_Id" = bc."Business_Id" and bc."Config_Name" = 'Can Use Shopify Checkout'
left join "BigCommerce_Product" bpr on p."BigCommerce_Product_Id" = bpr."Product_Id"
left join "BigCommerce_Product_Variant" bpv on pvl."BigCommerce_Product_Variant_Id" = bpv."Product_Variant_Id"
where b."Is_Active" = 'Y'
and pvl."Status" = 'active' and p."Status" = 'active'
and (pc."Name" is null or  UPPER(pc."Name") <> 'TIP')
order by up.Created_Date desc,pvl."Position";

insert into list
select p."Business_Id" "BusinessId"
	    ,p."Product_Description" "ProductDescription"
	    ,p."Product_Name" "ProductName" 
	    ,p."Product_Id" "ProductId"
	    ,p."productvid" "ProductVideoId"
	    ,pi."Image_Url" "ProductImage"
		,b."Business_Image" "BusinessImage"
		,b."Background_Image" "BusinessBackgroundImage"
		,b."Business_Name" "BusinessName"
		,b."Shortname" "BusinessShortName"
		,pvl."Product_Variant_List_Id" "ProductVariantListId"
	    ,pvl."Title" "ProductVariantKey"
		,'' "ProductVariantValue"
		,pv1."Product_Variant_List" "ProductVariantValue1"
		,pvl."Price"
		,ROW_NUMBER() OVER (PARTITION BY p."Product_Id",pvl."Product_Variant_List_Id" ORDER BY pi."Created_Date" ) AS rn	   
-- 		,dateadd(month,-1, GETDATE()) CreatedDate 
		,NOW() - interval '-1 month' "CreatedDate"
	    ,pvl."Price" "DiscountedPrice"
	    ,0 :: bit "IsDiscountAvailable"
	    ,null "DiscountPercentage"
	    ,pc."Name" "ProductCategory"
		,0 :: bit "IsCouponAvailable"
		,b."Order_Management_Sytem" "ECommercePlatform"
		,pvl."Title" "VariantName"
--         ,false :: boolean "IsInventoryTrackingAvailable"
--         ,'':: character varying "InventoryTracking"
--         ,0 ::  numeric "InventoryStockLevel"
--         ,0 ::  numeric "InventoryLowStockLevel"
--         ,false :: boolean "IsOutofStock"
from "Product" p 
join "Tip_Product" tp on p."Product_Id" = tp."Product_Id"
join "Business" b on tp."Business_Id" = b."Business_Id"
join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
left join "Product_Variant" pv on pvl."Product_Variant1_Id" = pv."Product_Variant_Id"
left join "Product_Variant" pv1 on pvl."Product_Variant2_Id" = pv1."Product_Variant_Id"
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join "Product_Category" pc on p."Product_Category_Id" = pc."Product_Category_Id"
where b."Business_Id" = businessid;
-- where UPPER(pc."Name") = 'TIP' 
-- 	  and  Lower(shortname) <> 'italybestcoffee' 
-- 	  and Lower(shortname) <> 'ayurveda';

OPEN refcursor1 FOR
select p.BusinessId "BusinessId"
	  ,p.Price "Price"
	  ,p.ProductDescription "ProductDescription"
	  ,p.ProductName "ProductName"
	  ,p.ProductId "ProductId"
	  ,p.ProductVideoId "ProductVideoId"
	  ,p.ProductImage "ProductImage"
	  ,p.BusinessImage "BusinessImage"
	  ,p.BusinessBackgroundImage "BusinessBackgroundImage"
	  ,p.BusinessName "BusinessName"
	  ,p.BusinessShortName "BusinessShortName"
	  ,p.ProductVariantListId "ProductVariantListId"
	  ,p.ProductVariantKey "ProductVariantKey"
	  ,CASE WHEN p.ProductVariantValue1 is not null 
		    THEN p.ProductVariantValue || ' / ' || p.ProductVariantValue1
	        ELSE p.ProductVariantValue
	   END "ProductVariantValue"
	  ,p.Price "Price"
	  ,p.CreatedDate "CreatedDate"
	  ,p.DiscountedPrice "DiscountedPrice"
	  ,p.IsDiscountAvailable "IsDiscountAvailable"
	  ,p.DiscountPercentage "DiscountPercentage"
	  ,p.ProductCategory "ProductCategory"
	  ,p.IsCouponAvailable "IsCouponAvailable"
	  ,shippingDetail "ShippingDetail"
	  ,p.ECommercePlatform "ECommercePlatform"
	  ,p.VariantName "VariantName"
	   ,p.StripeConnectAccountId "StripeConnectAccountId",
	   p.IsInventoryTrackingAvailable "IsInventoryTrackingAvailable",
    	p.InventoryTracking "InventoryTracking",
p.InventoryStockLevel "InventoryStockLevel",
p.InventoryLowStockLevel "InventoryLowStockLevel",
p.IsOutofStock "IsOutofStock",
p.ExternalProductId "ExternalProductId",
p.ProductVariantId "ProductVariantId"
from  list p
where "rn" = 1
order by p.CreatedDate desc;
 RETURN NEXT refcursor1;
 
OPEN refcursor2 FOR
select pi."Product_Id" "ProductId"
      ,pi."Image_Url" "ProductImage"
	  ,pi."Product_Image_Id" "ProductImageId"
	  ,pi."Desktop_Image_Url" "DesktopImageUrl"
	  ,pi."Mobile_Image_Url" "MobileImageUrl"
	  ,pi."Tablet_Image_Url" "TabletImageUrl"
from "Product" p
join "Product_Image" pi on p."Product_Id" = pi."Product_Id"
join upcomingProductList up on p."Product_Id" = up.Product_Id

UNION

select pi."Product_Id" "ProductId"
      ,pi."Image_Url" "ProductImage"
	  ,pi."Product_Image_Id" "ProductImageId"
	  ,pi."Desktop_Image_Url" "DesktopImageUrl"
	  ,pi."Mobile_Image_Url" "MobileImageUrl"
	  ,pi."Tablet_Image_Url" "TabletImageUrl"
from "Product" p
join "Tip_Product" tp on p."Product_Id" = tp."Product_Id"
join "Product_Image" pi on p."Product_Id" = pi."Product_Id"
join "Product_Category" pc on p."Product_Category_Id" = pc."Product_Category_Id"
where tp."Business_Id" = businessid;
-- where UPPER(pc."Name") = 'TIP' and Lower(shortname) <> 'italybestcoffee' and Lower(shortname) <> 'ayurveda' ;
 RETURN NEXT refcursor2; 
 
OPEN refcursor3 FOR
select pd."Product_Id" "ProductId"
      ,pd."Price" "Amount"
	  ,pd."Interval" 
	  ,pd."Interval_Count" "IntervalCount"
	  ,pd."Stripe_Price_Id" "StripePriceId"
	  ,pd."Subscription_Name" "SubscriptionName"
	  ,pd."product_variant_list_Id" "ProductVariantListId"
from "Product" p
join "Subscription_Price" pd on p."Product_Id" = pd."Product_Id"
join "Product_Variant_List" pvl on pd."product_variant_list_Id" = pvl."Product_Variant_List_Id"
join productList up on p."Product_Id" = up.Product_Id
where pd."Is_Active" = true
and pvl."Status" = 'active';
 RETURN NEXT refcursor3;
 
 DROP TABLE IF EXISTS pollinfo;
create table pollinfo(ProductId decimal(10),Poll varchar);

insert into pollinfo
select pi."Product_Id" ,pi."Poll_Info_Detail"
from "Poll_Info" pi
where pi."Unique_Id" = upcomingUniqueId
and pi."Poll_Type" = 2 ;

insert into pollinfo
select up."Product_Id",up."Poll_Info_Detail"
from "Upcoming_Live_Stream" ul
join "Upcoming_Poll_Info" up on ul."Media_Unique_Id" = up."Upcoming_Unique_Id"
where ul."Media_Unique_Id" = upcomingUniqueId
and up."Poll_Type" = 2 and "Is_Poll_Posted" = false;

DROP TABLE IF EXISTS videointeractivity;
CREATE TEMP TABLE videointeractivity AS
select vi."Product_Id",
	  vc."Channel_Id"
	  ,vi."Poll_Type"
	  ,vi."Ques_Desc" 
	  ,vi."Ques_Options"
	  ,p."Product_Name" 
	  ,pi."Image_Url" 
	  ,p."Product_Description" 
	  ,pvl."Price"
	  ,vi."Video_Interactivity_Id"
	  ,vi."Poll_Time"  
	  ,vc."Video_Unique_Id"
from "Video_Channel" vc
join "Video_Interactivity" vi on vc."Video_Channel_Id" = vi."Video_Channel_Id"
left join "Product" p on vi."Product_Id" = p."Product_Id"
left join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id" and pvl."Position" = 1
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
where vc."Video_Unique_Id" = upcomingUniqueId;

DROP TABLE IF EXISTS tipProduct;
CREATE TEMP TABLE tipProduct AS
select p."Product_Name" 
	  ,pi."Image_Url" 
	  ,p."Product_Description" 
	  ,pvl."Price"
	  ,p."Product_Id"
	  ,ci."Channel_Id"
from "Product" p
join "Tip_Product" tp on p."Product_Id" = tp."Product_Id"
join "Business" b on tp."Business_Id" = b."Business_Id"
join "Channel_Info" ci on b."Business_Id" = ci."Business_Id"
left join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id" and pvl."Position" = 1
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join "Product_Category" pc on p."Product_Category_Id" = pc."Product_Category_Id"
where b."Business_Id" = businessid;
-- where UPPER(pc."Name") = 'TIP' and  Lower(shortname) <> 'italybestcoffee' and Lower(shortname) <> 'ayurveda' ;

insert into pollinfo
select "Product_Id" "ProductId",json_build_object('ProductId',"Product_Id",
						 'ChannelId',"Channel_Id",
						 'Type',"Poll_Type",
						  'Description' , "Ques_Desc",
						 'Options',"Ques_Options",
						 'Item' , json_build_object(
						 'ItemId',"Product_Id",
							'Name' ,"Product_Name",
							 'ItemUrl',"Image_Url",
							 'Type',"Poll_Type",
							 'Description',"Product_Description",
							 'Price',"Price",
							 'Quantity',0
						 ),
						 'PollInfoId',"Video_Interactivity_Id",
						 'PollElapsedTime',"Poll_Time",
						 'PollUniqueId',"Video_Unique_Id"
						) :: varchar "Poll_Info_Detail" 
from videointeractivity;

insert into pollinfo
select "Product_Id" "ProductId",json_build_object('ProductId',"Product_Id",
						 'ChannelId',"Channel_Id",
						 'Type',2,
						  'Description' , null,
						 'Options',null,
						 'Item' , json_build_object(
						 'ItemId',"Product_Id",
							'Name' ,"Product_Name",
							 'ItemUrl',"Image_Url",
							 'Type',2,
							 'Description',"Product_Description",
							 'Price',"Price",
							 'Quantity',0
						 ),
						 'PollInfoId',1,
						 'PollElapsedTime',1,
						 'PollUniqueId','"Video_Unique_Id"'
						) :: varchar "Poll_Info_Detail" 
from tipProduct;
 
OPEN refcursor4 FOR
select ProductId "ProductId" 
	  ,Poll "Poll"
from pollinfo;
 RETURN NEXT refcursor4;

OPEN refcursor5 FOR
select "Business_Payment_Method_Id" "BusinessPaymentMethodId" 
	  ,"Payment_Method" "PaymentMethod"
	  ,"Sort_Order" "sortorder"
	  ,"Payment_Integration" "PaymentIntegration"
from "Business_Payment_Methods"
where "Business_Id" = businessId 
and "Is_Active" = true;
 RETURN NEXT refcursor5;
 
 OPEN refcursor6 FOR
select * from 
(select pr."Product_Id" "ProductId"
	  ,'' "ReviewTitle"
      ,pr."Review_Detail"  "ReviewDetail"
	  ,pr."Review_Rating" "ReviewRating"
	  ,pr."UserId"
	  ,COALESCE(u."UserName","User_Name") "UserName"
	  ,COALESCE(u."ImageUrl",'') "User_Profile_Image"
	  ,0 "BusinessId"
from "Product" p
 join "Business_Product" bp on p."Product_Id" = bp."Product_id"
join "Product_Review" pr on p."Product_Id" = pr."Product_Id"
left join "AspNetUsers" u on pr."UserId" = u."Id"
where bp."Business_Id" = businessId
and (p."Product_Category_Id" = productCategoryId or productCategoryId is null) and p."Status" = 'active'

UNION 

select 0 "ProductId"
	  ,"Review_Title" "ReviewTitle"
	  ,"Review_Detail" as "ReviewDetail"
	  ,"Review_Rating" "ReviewRating"
	  ,'' "UserId"
	  ,"User_Name" "UserName"
	  ,'' "User_Profile_Image"
	  ,"Business_Id" "BusinessId"
from "Business_Review"
where "Business_Id" =businessId) review;
 RETURN NEXT refcursor6;

 OPEN refcursor7 FOR
select pi."Product_Id" "ProductId"
      ,pi."Image_Url" "ProductImage"
	  ,pi."Product_Image_Id" "ProductImageId"
	  ,pi."Desktop_Image_Url" "DesktopImageUrl"
	  ,pi."Mobile_Image_Url" "MobileImageUrl"
	  ,pi."Tablet_Image_Url" "TabletImageUrl"
	  ,pvl."Product_Variant_List_Id" "ProductVariantListId"
from "Product" p
join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
join "Product_Image" pi on pvl."Product_Variant_List_Id" = pi."Product_Variant_List_Id"
join upcomingProductList up on p."Product_Id" = up.Product_Id;
 RETURN NEXT refcursor7;
 
END
$BODY$;
