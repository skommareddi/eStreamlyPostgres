﻿
CREATE PROCEDURE [dbo].[CreateWooCommerceProducts]
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
select sp.*,pc.Product_Category_Id,pc.Name
into #products
from Wc_Product sp 
left join Product_Category pc on sp.Product_Type = pc.Name
where sp.Business_Id = @businessId


MERGE Product AS TARGET
USING #products AS SOURCE 
ON (TARGET.Wc_Product_Id = SOURCE.Wc_Product_Id) 

WHEN MATCHED AND TARGET.Product_Name <> SOURCE.Title OR TARGET.Product_Description <> SOURCE.Description OR  TARGET.Product_Category_Id <> SOURCE.Product_Category_Id
THEN UPDATE SET TARGET.Product_Name = SOURCE.Title , TARGET.Product_Description = SOURCE.Description ,  TARGET.Product_Category_Id = SOURCE.Product_Category_Id

WHEN NOT MATCHED BY TARGET 
THEN INSERT (Business_Id,Product_Name,Product_Description,Product_Category_Id,status,Wc_Product_Id, created_date,created_by) 
VALUES (SOURCE.Business_Id,SOURCE.Title,SOURCE.Description,SOURCE.Product_Category_Id,Source.Status,source.Wc_Product_Id, getdate(),'');


select p.Product_Id
	  ,pm.Product_Measurement_Id
	  ,spv.Price
	  ,spv.Weight
	  ,pv1.Product_Variant_Id Product_Variant1_Id
	  ,pv1.Product_Variant_List Product_Variant1
	  ,pv2.Product_Variant_Id Product_Variant2_Id
	  ,pv2.Product_Variant_List Product_Variant2
	  ,pv3.Product_Variant_Id Product_Variant3_Id
	  ,pv3.Product_Variant_List Product_Variant3
	  ,spv.Wc_Product_Variant_Id 
	  ,spv.Title
	  ,spv.Wc_Product_Id
INTO #productVariantlist
from Wc_Product sp
join Wc_Product_Variants spv on sp.Wc_Product_Id = spv.Wc_Product_Id
join Product p on sp.WC_Product_Id = p.WC_Product_Id
left join Product_Measurement pm on spv.Weight_Unit = pm.Product_Measurement_Name
left join Product_Variant pv1 on spv.Option1 = pv1.Product_Variant_List
left join Product_Variant pv2 on spv.Option2 = pv2.Product_Variant_List
left join Product_Variant pv3 on spv.Option3 = pv3.Product_Variant_List
where pv1.Product_Variant_Id is not null
and sp.business_id = @businessId

MERGE Product_Variant_List AS TARGET
USING #productVariantlist AS SOURCE 
ON (TARGET.Wc_Product_Variants_Id = SOURCE.Wc_Product_Variant_Id and TARGET.Product_Id = SOURCE.Product_Id) 

WHEN MATCHED --AND TARGET.variant_value1 <> SOURCE.Product_Variant1 OR TARGET.variant_value2 <> SOURCE.Product_Variant2 OR  TARGET.variant_value3 <> SOURCE.Product_Variant1
THEN UPDATE SET TARGET.Product_Variant1_id = SOURCE.Product_Variant1_Id,TARGET.Product_Variant2_id = SOURCE.Product_Variant2_Id,TARGET.Product_Variant3_id = SOURCE.Product_Variant3_Id, TARGET.variant_value1 = SOURCE.Product_Variant1 , TARGET.variant_value2 = SOURCE.Product_Variant2 ,  TARGET.variant_value3 = SOURCE.Product_Variant3

WHEN NOT MATCHED BY TARGET 
THEN INSERT (Product_Id,Product_Measurement_Id,Price,Weight,Product_Variant1_id,variant_value1,Product_Variant2_id,variant_value2,Wc_Product_Variants_Id,title, created_date,created_by,Product_Variant3_id,variant_value3) 
VALUES (SOURCE.Product_Id,SOURCE.Product_Measurement_Id,SOURCE.Price,SOURCE.Weight,Source.Product_Variant1_Id,Source.Product_Variant1,Source.Product_Variant2_Id,Source.Product_Variant2,source.Wc_Product_Variant_Id,source.title, getdate(),'',Source.Product_Variant3_Id,Source.Product_Variant3);

drop table #products
drop table #productVariantlist

END