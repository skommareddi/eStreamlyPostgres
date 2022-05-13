
CREATE PROCEDURE [dbo].[CreateShopifyProductVariants]
(
 @businessId decimal(10)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
select distinct Option1
into #productvariant1
from shopify_product sp
join Shopify_Product_Variants spv on sp.shopify_product_id = spv.shopify_product_id
where Option1 <> '' and sp.business_id = @businessId
and sp.Status = 'active' 

select distinct Option2
into #productvariant2
from shopify_product sp
join Shopify_Product_Variants spv on sp.shopify_product_id = spv.shopify_product_id
where Option2 <> '' and sp.business_id = @businessId
and sp.Status = 'active' 

select distinct Option3
into #productvariant3
from shopify_product sp
join Shopify_Product_Variants spv on sp.shopify_product_id = spv.shopify_product_id
where Option3 <> '' and sp.business_id = @businessId
and sp.Status = 'active' 

MERGE Product_Variant AS TARGET
USING #productvariant1 AS SOURCE
ON (TARGET.Product_Variant_List = SOURCE.Option1)

WHEN NOT MATCHED BY TARGET
THEN INSERT (Product_Variant_Name,Product_Variant_List, created_date,created_by) VALUES ('',SOURCE.option1, getdate(),'');

MERGE Product_Variant AS TARGET
USING #productvariant2 AS SOURCE
ON (TARGET.Product_Variant_List = SOURCE.Option2)

WHEN NOT MATCHED BY TARGET
THEN INSERT (Product_Variant_Name,Product_Variant_List, created_date,created_by) VALUES ('',SOURCE.option2, getdate(),'');

MERGE Product_Variant AS TARGET
USING #productvariant3 AS SOURCE
ON (TARGET.Product_Variant_List = SOURCE.Option3)

WHEN NOT MATCHED BY TARGET
THEN INSERT (Product_Variant_Name,Product_Variant_List, created_date,created_by) VALUES ('',SOURCE.option3, getdate(),'');

END