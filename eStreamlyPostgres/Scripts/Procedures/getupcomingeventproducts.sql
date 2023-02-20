
CREATE OR REPLACE FUNCTION public.getupcomingeventproducts(
	)
    RETURNS TABLE(businessid bigint, productdescription character varying, productname character varying, productid bigint, productimage character varying, businessimage character varying, businessbackgroundimage character varying, businessname character varying, businessshortname character varying, productvariantlistid bigint, productvariantkey character varying, productvariantvalue character varying, productvariantvalue1 character varying, price numeric, rn bigint, createddate timestamp with time zone, discountedprice numeric, isdiscountavailable integer, discountpercentage numeric, desktopimageurl character varying, tabletimageurl character varying, mobileimageurl character varying, productsortdate timestamp with time zone) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

	DECLARE 
     BEGIN
    
CREATE TEMP TABLE upcomingEvents AS    
        select ul."Media_Unique_Id" upcomingUniqueId
	  ,ci."Business_Id" BusinessId
	  ,ls."Created_Date" CreatedDate 
	  ,up."Product_Id"
from "Upcoming_Live_Stream" ul
join "Channel_Info" ci on ul."Channel_Id" = ci."Channel_Id"
join "Upcoming_Poll_Info" up on ul."Media_Unique_Id" = up."Upcoming_Unique_Id"
join "Live_Stream_Info" ls on ul."Media_Unique_Id" = ls."Unique_Id"
where ul."Is_Private_Event" = '0' 
	and up."Poll_Type" = 2
	and "Is_Poll_Posted" = '0';
	RETURN QUERY
with discountOffer as (
select dof.*
from "Discount_Offer" dof
join upcomingEvents ue on dof."Business_Id" = ue.BusinessId
where  NOW()  between "Valid_Start_Date" and "Valid_End_Date"
)
	select * 
from (select p."Business_Id" BusinessId
	    ,p."Product_Description" ProductDescription
	    ,p."Product_Name" ProductName 
	    ,p."Product_Id" ProductId
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
		,ROW_NUMBER() OVER (PARTITION BY p."Product_Id",pvl."Product_Variant_List_Id" ORDER BY pi."Created_Date",up.CreatedDate desc ) AS rn	   
		,up.CreatedDate CreatedDate
		,COALESCE(cast (pvl."Price"  - (pvl."Price"  * dof."Discount_Percentage" / 100) as decimal(10,2)),pvl."Price") DiscountedPrice
		,CASE WHEN dof."Discount_Percentage" > 0 THEN 1 ELSE 0 END IsDiscountAvailable	
		,dof."Discount_Percentage" DiscountPercentage
		,pi."Desktop_Image_Url" DesktopImageUrl
		,pi."Tablet_Image_Url" TabletImageUrl
		,pi."Mobile_Image_Url" MobileImageUrl
		,up.CreatedDate ProductSortDate
from "Product" p 
join "Business" b on p."Business_Id" = b."Business_Id"
join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
left join "Product_Variant" pv on pvl."Product_Variant1_Id" = pv."Product_Variant_Id"  
left join "Product_Variant" pv1 on pvl."Product_Variant2_Id" = pv1."Product_Variant_Id"
join upcomingEvents up on p."Product_Id" = up."Product_Id"
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join discountOffer dof on b."Business_Id" = dof."Business_Id" 
						and (dof."Product_Id" is null or dof."Product_Id" = p."Product_Id")
where b."Is_Active" = 'Y'
and pvl."Status" = 'active'
and pvl."Position" = 1) pl
where pl.rn = 1
order by ProductSortDate desc;

DROP TABLE upcomingEvents;
END; 
$BODY$;

