
CREATE PROCEDURE [dbo].[GetAllProducts]
(@pageNumber int,
 @pageSize int )
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
;with discountOffer as (
select *
from Discount_Offer do
where GETDATE()  between valid_start_date and valid_end_date)

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
		    THEN ProductVariantValue + ' / ' + ProductVariantValue1
	        ELSE ProductVariantValue 
	   END ProductVariantValue
	  ,ISNULL(DiscountedPrice,Price) DiscountedPrice
	  ,IsDiscountAvailable
	  ,DiscountPercentage
	  ,CAST(0 as decimal(10,2)) Rating
	  ,0 RatingCount
	  ,ProductCategory 
INTO #productList
from (
select p.Business_Id BusinessId
	    ,p.Product_Description ProductDescription
	    ,p.Product_Name ProductName 
	    ,p.Product_Id ProductId
	    ,CASE WHEN p.productvid is null OR p.Product_Id = '' THEN pvi.Video_Url ELSE p.productvid END ProductVideoId
	    ,pi.Image_Url ProductImage
		,b.Business_Image BusinessImage
		,b.Background_Image BusinessBackgroundImage
		,b.Business_Name BusinessName
		,b.Shortname BusinessShortName
		,pvl.Product_Variant_List_Id ProductVariantListId
	    ,pv.Product_Variant_Name ProductVariantKey
		,pv.Product_Variant_List ProductVariantValue
		,pv1.Product_Variant_List ProductVariantValue1
		,pvl.Price
		,ROW_NUMBER() OVER (PARTITION BY p.product_id,pvl.product_variant_list_Id ORDER BY pi.Created_Date ) AS rn
		,cast (pvl.Price  - (pvl.Price  * do.Discount_Percentage / 100) as decimal(10,2)) DiscountedPrice
		,CASE WHEN do.Discount_Percentage > 0 THEN 1 ELSE 0 END IsDiscountAvailable
		,do.Discount_Percentage DiscountPercentage
		,pc.Name ProductCategory
from Product p 
join Business b on p.Business_Id = b.Business_Id
join product_variant_list pvl on p.Product_Id = pvl.Product_Id
left join Product_Variant pv on pvl.Product_Variant1_Id = pv.Product_Variant_Id
left join Product_Variant pv1 on pvl.Product_Variant2_Id = pv1.Product_Variant_Id
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.position = 1
left join Product_Video pvi on p.Product_Id = pvi.Product_Id
left join Product_Category pc on p.Product_Category_Id = pc.Product_Category_Id
left join discountOffer do on b.Business_Id = do.Business_Id and (do.product_id is null or do.product_id = p.Product_Id)
and p.Status = 'active' where pvl.position = 1
and pvl.status = 'active'
) p
where rn = 1
ORDER BY p.ProductId--NEWID() --p.ProductId
OFFSET ((@pageNumber - 1) * @pageSize) ROWS
FETCH NEXT @pageSize ROWS ONLY;


Update p set RatingCount = review.RatingCount
	  ,Rating = review.Rating
from 
(select pr.Product_Id ProductId	  
	  ,COUNT(pr.Review_Rating) RatingCount
	  ,CAST(SUM(pr.Review_Rating) / COUNT(pr.Review_Rating) as decimal(10,2))  Rating
from #productList p
join Product_Review pr on p.ProductId = pr.Product_Id
left join AspNetUsers u on pr.UserId = u.Id
group by pr.Product_Id
) review
join #productList p on review.ProductId = p.ProductId

select * 
from #productList

drop table #productList
END