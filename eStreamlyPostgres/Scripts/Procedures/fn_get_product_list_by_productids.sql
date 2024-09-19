CREATE OR REPLACE FUNCTION public.fn_get_product_list_by_productids(
	ids text[],
	businessid numeric,
	refcursor1 refcursor,
	refcursor2 refcursor,
	refcursor3 refcursor,
	refcursor4 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

	BEGIN

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
	DiscountedPrice decimal(10,2) not null,
	rn int,
	ProductCategory varchar(250),
	ECommercePlatform varchar(250),
	VariantName varchar(250),
	StripeConnectAccountId varchar(250),
	Sku varchar(250),
	IsInventoryTrackingAvailable boolean,
	InventoryTracking varchar(250),
	InventoryStockLevel numeric null,
	InventoryLowStockLevel numeric null,
	IsOutofStock boolean,
	ExternalProductId bigint null,	
    ProductVariantId bigint null
	);

	INSERT into list
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
			,case when pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 then pvl."CompareAtPrice" else pvl."Price"  End "Price"
			,case when pvl."CompareAtPrice"  is not null and pvl."CompareAtPrice" > 0 then pvl."CompareAtPrice" else pvl."Price"  End "DiscountedPrice"
			,ROW_NUMBER() OVER (PARTITION BY p."Product_Id",pvl."Product_Variant_List_Id") AS "rn"	   
			,pc."Name" "ProductCategory"
			,CASE when LOWER(b."Order_Management_Sytem") = 'shopify' and bc."Config_Value" = 'Y' then 'shopify'
				 when LOWER(b."Order_Management_Sytem") = 'shopify' then null
				 else LOWER(b."Order_Management_Sytem") END "ECommercePlatform"
			,pvl."Title" "VariantName"
			,b."Stripe_Connect_Account_Id" "StripeConnectAccountId"
			,pvl."Sku" "Sku"
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
-- 	join "Business_Product" bp on p."Product_Id" = bp."Product_id"
	join "Business" b on p."Business_Id" = b."Business_Id"
	join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
	left join "Product_Variant" pv on pvl."Product_Variant1_Id" = pv."Product_Variant_Id"
	left join "Product_Variant" pv1 on pvl."Product_Variant2_Id" = pv1."Product_Variant_Id"
	left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
	left join "Product_Category" pc on p."Product_Category_Id" = pc."Product_Category_Id"
	left join "Business_Config" bc on b."Business_Id" = bc."Business_Id" and bc."Config_Name" = 'Can Use Shopify Checkout'
	left join "BigCommerce_Product" bpr on p."BigCommerce_Product_Id" = bpr."Product_Id"
left join "BigCommerce_Product_Variant" bpv on pvl."BigCommerce_Product_Variant_Id" = bpv."Product_Variant_Id"
	where b."Is_Active" = 'Y'
	and pvl."Status" = 'active' and p."Status" = 'active'
	and p."Product_Id"  = ANY (ARRAY(SELECT UNNEST(ids)::bigint))
	order by pvl."Position";

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
		  ,p.DiscountedPrice "DiscountedPrice"
		  ,p.ProductCategory "ProductCategory"
		  ,p.ECommercePlatform "ECommercePlatform"
		  ,p.VariantName "VariantName"
		   ,p.StripeConnectAccountId "StripeConnectAccountId"
		   ,p.Sku "Sku",
		   p.ExternalProductId "ExternalProductId",
           p.ProductVariantId "ProductVariantId",
p.IsInventoryTrackingAvailable "IsInventoryTrackingAvailable",
p.InventoryTracking "InventoryTracking",
p.InventoryLowStockLevel "InventoryLowStockLevel",
p.IsOutofStock "IsOutofStock",
p.InventoryStockLevel "InventoryStockLevel"
	from  list p;
-- 	where "rn" = 1;
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
join list up on p."Product_Id" = up.ProductId;
RETURN NEXT refcursor2;

	OPEN refcursor3 FOR
	select pi."Product_Id" "ProductId"
		  ,pi."Image_Url" "ProductImage"
		  ,pi."Product_Image_Id" "ProductImageId"
		  ,pi."Desktop_Image_Url" "DesktopImageUrl"
		  ,pi."Mobile_Image_Url" "MobileImageUrl"
		  ,pi."Tablet_Image_Url" "TabletImageUrl"
		  ,pvl."Product_Variant_List_Id" "ProductVariantListId"
	from "Product" p
	join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
	join "Product_Variant_Image" pvi on  p."Product_Id" = pvi."Product_Id" and  pvi."Product_Variant_List_Id" = pvl."Product_Variant_List_Id"
	join "Product_Image" pi on pvl."Product_Variant_List_Id" = pi."Product_Variant_List_Id"
	join list up on p."Product_Id" = up.ProductId;
	RETURN NEXT refcursor3;
	
	OPEN refcursor4 FOR
select "Business_Payment_Method_Id" "BusinessPaymentMethodId" 
	  ,"Payment_Method" "PaymentMethod"
	  ,"Sort_Order" "sortorder"
	  ,"Payment_Integration" "PaymentIntegration"
from "Business_Payment_Methods"
where "Business_Id" = businessId 
and "Is_Active" = true;
 RETURN NEXT refcursor4;

	END
	
$BODY$;