-- =============================================
-- Author:		Smitha
-- Create date: 2/2/2022
-- Description:	creates products and business urls for sitemap. 
-- =============================================
CREATE PROCEDURE [dbo].[SitemapXML]
	
AS
BEGIN
	select   xml= '<url><loc>https://estreamly.com/product/'+convert(varchar, Product_Id) + '</loc></url>' 
from Product
where Status ='active'
select   xml= '<url><loc>https://estreamly.com/'+convert(varchar, Shortname) + '</loc></url>' 
from [Business]
where Is_Active = 'Y'
END