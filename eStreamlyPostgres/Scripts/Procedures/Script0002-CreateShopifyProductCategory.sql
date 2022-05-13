CREATE PROCEDURE [dbo].[CreateShopifyProductCategory]
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
   select distinct Product_Type into #producttype
from Shopify_Product 
where Product_Type <> '' and Business_Id = @businessId
and Status = 'active'

MERGE Product_Category AS TARGET
USING #producttype AS SOURCE 
ON (TARGET.Name = SOURCE.Product_Type) 

WHEN NOT MATCHED BY TARGET 
THEN INSERT (name, created_date,created_by) VALUES (SOURCE.Product_Type, getdate(),'');
END