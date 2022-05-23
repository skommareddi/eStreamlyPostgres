CREATE  PROCEDURE [dbo].[CreateShopifyProductMeasurement]
(
    -- Add the parameters for the stored procedure here
    @businessId decimal(10)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
   select distinct Weight_Unit 
into #productmeasurement
from Shopify_Product sp
join Shopify_Product_Variants spv on sp.Shopify_Product_Id = spv.Shopify_Product_Id
where Weight_Unit <> '' and sp.Business_Id = @businessId
and status = 'active'

MERGE Product_Measurement AS TARGET
USING #productmeasurement AS SOURCE 
ON (TARGET.Product_Measurement_Name = SOURCE.Weight_Unit) 

WHEN NOT MATCHED BY TARGET 
THEN INSERT (Product_Measurement_name, created_date,created_by) VALUES (SOURCE.Weight_Unit, getdate(),'');
END