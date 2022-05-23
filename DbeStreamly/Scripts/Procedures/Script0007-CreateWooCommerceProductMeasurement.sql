
CREATE PROCEDURE [dbo].[CreateWooCommerceProductMeasurement]
(
    -- Add the parameters for the stored procedure here
 @businessId decimal(10,0)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
select distinct Weight_Unit 
into #productmeasurement
from Wc_Product sp
join Wc_Product_Variants spv on sp.Wc_Product_Id = spv.Wc_Product_Id
where Weight_Unit <> '' and sp.Business_Id = @businessId

select * from #productmeasurement

MERGE Product_Measurement AS TARGET
USING #productmeasurement AS SOURCE 
ON (TARGET.Product_Measurement_Name = SOURCE.Weight_Unit) 

WHEN NOT MATCHED BY TARGET 
THEN INSERT (Product_Measurement_name, created_date,created_by) VALUES (SOURCE.Weight_Unit, getdate(),'');
END