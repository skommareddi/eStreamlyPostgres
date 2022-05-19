CREATE OR REPLACE FUNCTION GetAllProducts( IN pageNumber integer,IN pageSize integer,ref refcursor) 
RETURNS refcursor AS $$
BEGIN

DROP TABLE IF EXISTS discountOffer;
CREATE TEMP TABLE discountOffer AS
select *
from public."Discount_Offer"
where DATE(NOW()) between DATE("Valid_Start_Date") and date("Valid_End_Date");

DROP TABLE IF EXISTS productList;
CREATE TEMP TABLE productList AS
select BusinessId
	  ,Price
	  ,ProductDescription
	  ,ProductName
	  ,ProductId
	  ,ProductVideoId
	  ,ProductImage
	  ,BusinessImage
	  ,BusinessBackgroundImage
	  ,BusinessName
	  ,BusinessShortName
	  ,ProductVariantListId
	  ,ProductVariantKey
	  ,CASE WHEN ProductVariantValue1 is not null 
		    THEN CONCAT(ProductVariantValue , ' / ' , ProductVariantValue1)
	        ELSE ProductVariantValue 
	   END ProductVariantValue
  ,coalesce(DiscountedPrice,Price) DiscountedPrice
 	  ,IsDiscountAvailable
  ,DiscountPercentage
	  ,CAST(0 as decimal(10,2)) Rating
	  ,0 RatingCount
	  ,ProductCategory 
-- INTO #productList
from (
select p."Business_Id" BusinessId
	    ,p."Product_Description" ProductDescription
	    ,p."Product_Name" ProductName 
	    ,p."Product_Id" ProductId
	    ,CASE WHEN p."productvid" is null THEN pvi."Video_Url" ELSE p."productvid" END ProductVideoId
	    ,pi."Image_Url" ProductImage
		,b."Business_Image" BusinessImage
		,b."Background_Image" BusinessBackgroundImage
		,b."Business_Name" BusinessName
		,b."Shortname" BusinessShortName
		,pvl."Product_Variant_List_Id" ProductVariantListId
	    ,pv."Product_Variant_Name" ProductVariantKey
		,pv."Product_Variant_List" ProductVariantValue
		,pv1."Product_Variant_List" ProductVariantValue1
		,pvl."Price" Price
		,ROW_NUMBER() OVER (PARTITION BY p."Product_Id",pvl."Product_Variant_List_Id" ORDER BY pi."Created_Date" ) AS rn
	,cast (pvl."Price"  - (pvl."Price"  * d."Discount_Percentage" / 100) as decimal(10,2)) DiscountedPrice
	,CASE WHEN d."Discount_Percentage" > 0 THEN 1 ELSE 0 END IsDiscountAvailable
	,d."Discount_Percentage" DiscountPercentage
		,pc."Name" ProductCategory
from public."Product" p 
join public."Business" b on p."Business_Id" = b."Business_Id"
join public."Product_Variant_List" pvl ON pvl."Product_Id" = p."Product_Id"
left join public."Product_Variant" pv on pvl."Product_Variant1_Id" = pv."Product_Variant_Id"
left join public."Product_Variant" pv1 on pvl."Product_Variant2_Id" = pv1."Product_Variant_Id"
left join public."Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join public."Product_Video" pvi on p."Product_Id" = pvi."Product_Id"
left join public."Product_Category" pc on p."Product_Category_Id" = pc."Product_Category_Id"
left join discountOffer d on b."Business_Id" = d."Business_Id" 
						and (d."Product_Id" is null or d."Product_Id" = p."Product_Id")
and p."Status" = 'active' where pvl."Position" = 1
and pvl."Status" = 'active'
) p
where rn = 1
ORDER BY p.ProductId--NEWID() --p.ProductId
LIMIT pageSize OFFSET pageNumber;


Update productList set RatingCount = review.RatingCount
	  ,Rating = review.Rating
from 
(select pr."Product_Id" ProductId	  
	  ,COUNT(pr."Review_Rating") RatingCount
	  ,CAST(SUM(pr."Review_Rating") / COUNT(pr."Review_Rating") as decimal(10,2))  Rating
from productList p
join public."Product_Review" pr on p.ProductId = pr."Product_Id"
left join public."AspNetUsers" u on pr."UserId" = u."Id"
group by pr."Product_Id"
) review
join productList p on review.ProductId = p.ProductId;

OPEN ref FOR  select * 
			  from productList;
			  
RETURN ref;

DROP TABLE productList;
DROP TABLE discountOffer;
END
$$ LANGUAGE plpgsql;