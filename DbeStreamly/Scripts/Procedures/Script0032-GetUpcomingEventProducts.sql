CREATE PROCEDURE [dbo].[GetUpcomingEventProducts]
AS

BEGIN

select ul.Media_Unique_Id upcomingUniqueId
	  ,ci.Business_Id BusinessId
	  ,ls.Created_Date CreatedDate 
	  ,up.Product_Id
INTO #upcomingEvents
from Upcoming_Live_Stream ul
join Channel_Info ci on ul.Channel_Id = ci.Channel_Id
join Upcoming_Poll_Info up on ul.Media_Unique_Id = up.Upcoming_Unique_Id
join Live_Stream_Info ls on ul.Media_Unique_Id = ls.unique_id
where ul.is_private_event = 0 
	and up.Poll_Type = 2
	and Is_Poll_Posted = 0
--where Start_Date_Time > GETDATE()

--create table #upcomingProductList(Product_Id decimal(10),Created_Date datetime)

--insert into #upcomingProductList
--select up.Product_Id
--	  ,ue.CreatedDate Created_Date
--from  Upcoming_Poll_Info up
--join #upcomingEvents ue on up.Upcoming_Unique_Id = ue.upcomingUniqueId
--where up.Poll_Type = 2 and Is_Poll_Posted = 0

;with discountOffer as (
select do.*
from Discount_Offer do
join #upcomingEvents ue on do.Business_Id = ue.BusinessId
where  GETDATE()  between Valid_Start_Date and Valid_End_Date
)

select * 
from (select p.Business_Id BusinessId
	    ,p.Product_Description ProductDescription
	    ,p.Product_Name ProductName 
	    ,p.Product_Id ProductId
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
		,ROW_NUMBER() OVER (PARTITION BY p.product_id,pvl.product_variant_list_Id ORDER BY pi.Created_Date,up.CreatedDate desc ) AS rn	   
		,up.CreatedDate CreatedDate
		,ISNULL(cast (pvl.Price  - (pvl.Price  * do.Discount_Percentage / 100) as decimal(10,2)),pvl.Price) DiscountedPrice
		,CASE WHEN do.Discount_Percentage > 0 THEN 1 ELSE 0 END IsDiscountAvailable	
		,do.Discount_Percentage DiscountPercentage
		,pi.Desktop_Image_Url DesktopImageUrl
		,pi.Tablet_Image_Url TabletImageUrl
		,pi.Mobile_Image_Url MobileImageUrl
		,up.CreatedDate ProductSortDate
from Product p 
join Business b on p.Business_Id = b.Business_Id
join product_variant_list pvl on p.Product_Id = pvl.Product_Id
left join Product_Variant pv on pvl.Product_Variant1_Id = pv.Product_Variant_Id  
left join Product_Variant pv1 on pvl.Product_Variant2_Id = pv1.Product_Variant_Id
join #upcomingEvents up on p.Product_Id = up.Product_Id
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.Position = 1
left join discountOffer do on b.Business_Id = do.Business_Id 
						and (do.Product_Id is null or do.Product_Id = p.Product_Id)
where b.Is_Active = 'Y'
and pvl.status = 'active'
and pvl.Position = 1) pl
where rn = 1
order by ProductSortDate desc--CreatedDate desc

--drop table #upcomingProductList
drop table #upcomingEvents
END;