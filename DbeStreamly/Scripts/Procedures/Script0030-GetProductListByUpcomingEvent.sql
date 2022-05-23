CREATE PROCEDURE [dbo].[GetProductListByUpcomingEvent](@upcomingUniqueId varchar(250),@businessId decimal(10)) -- GetProductListByUpcomingEvent 'llXuKDrctmw',8
AS
BEGIN

Declare @shortname nvarchar(500);

Declare @productCategoryId decimal(10),
		@startDate datetime,
		@endDate datetime,
		@shippingDetail nvarchar(max);

select @startDate = u.Start_Date_Time,@endDate = u.End_Date_Time
from Upcoming_Live_Stream u
where u.Media_Unique_Id = @upcomingUniqueId

select @shortname = shortname 
from Business 
where business_id = @businessId

select @shippingDetail=  CASE WHEN pd.Max_Order_Amount > 0 and pd.shipping_amount > 0 THEN 'Free US standard shipping for orders valued at $'+ cast(pd.Max_Order_Amount as varchar(50))+' or more </br> $' + cast(pd.Shipping_Amount as varchar(50))+' Standard Flat Rate Shipping' 
							  WHEN pd.Max_Order_Amount > 0 THEN 'Free US standard shipping for orders valued at $'+ cast(pd.Max_Order_Amount as varchar(50))+' or more </br>' 
							  WHEN pd.shipping_amount > 0 THEN '$' + cast(pd.Shipping_Amount as varchar(50))+' Standard Flat Rate Shipping' 
							ELSE '' END
from Product_Shipping_Detail pd
where pd.Business_Id = @businessId

create table #upcomingProductList(Product_Id decimal(10),Created_Date datetime)

insert into #upcomingProductList
select pi.Product_Id
	  ,pi.Created_Date Created_Date
from Poll_Info [pi]
where pi.Unique_Id = @upcomingUniqueId
and pi.Poll_Type = 2 

insert into #upcomingProductList
select up.Product_Id
	  ,up.Created_Date Created_Date
from Upcoming_Live_Stream ul
join Upcoming_Poll_Info up on ul.Media_Unique_Id = up.Upcoming_Unique_Id
where ul.Media_Unique_Id = @upcomingUniqueId
and up.Poll_Type = 2 and Is_Poll_Posted = 0

insert into #upcomingProductList
select vi.Product_Id
	  ,vi.Created_Date Created_Date
from Video_Channel vc
join Video_Interactivity vi on vc.Video_Channel_Id = vi.Video_Channel_Id
where vc.Video_Unique_Id= @upcomingUniqueId

select Product_Id
	  ,Created_Date 
INTO #productList
from (select * 
		  ,ROW_NUMBER() over(partition by product_id order by Created_Date desc) rn
	  from #upcomingProductList ) u 
where rn = 1

create table #list (
BusinessId bigint not null,
ProductDescription varchar(max),
ProductName varchar(250),
ProductId bigint not null,
ProductVideoId varchar(250),
ProductImage varchar(max),
BusinessImage varchar(max),
BusinessBackgroundImage varchar(max),
BusinessName varchar(250),
BusinessShortName varchar(250),
ProductVariantListId  bigint not null,
ProductVariantKey varchar(250),
ProductVariantValue varchar(250),
ProductVariantValue1 varchar(250),
Price decimal(10,2) not null,
rn int,
CreatedDate datetime,
DiscountedPrice decimal(10,2) null,
IsDiscountAvailable bit,
DiscountPercentage numeric null,
ProductCategory varchar(250),
IsCouponAvailable bit
)

;with discountOffer as (
select *
from Discount_Offer do
where Business_id = @businessId
and GETDATE() between Valid_Start_Date and Valid_End_Date
), coupon as 
(
select * 
from Discount_Coupon dc
where Business_Id = @businessId
--and GETDATE() between Valid_Start_Date and Valid_End_Date\
and ( GETDATE()  between valid_start_date and valid_end_date)
)

INSERT into #list
select p.Business_Id BusinessId
	    ,p.Product_Description ProductDescription
	    ,p.Product_Name ProductName 
	    ,p.Product_Id ProductId
	    ,p.productvid ProductVideoId
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
		,ROW_NUMBER() OVER (PARTITION BY p.product_id,pvl.product_variant_list_Id ORDER BY pi.Created_Date,up.Created_Date desc ) AS rn	   
		,up.Created_Date CreatedDate
		,ISNULL(cast (pvl.Price  - (pvl.Price  * do.Discount_Percentage / 100) as decimal(10,2)),pvl.Price) DiscountedPrice
		,CASE WHEN do.Discount_Percentage > 0 THEN 1 ELSE 0 END IsDiscountAvailable	
		,do.Discount_Percentage DiscountPercentage
		,pc.Name ProductCategory
		,CASE WHEN c.Discount_Percentage > 0 THEN 1 ELSE 0 END IsCouponAvailable
from Product p 
join Business b on p.Business_Id = b.Business_Id
join product_variant_list pvl on p.Product_Id = pvl.Product_Id
left join Product_Variant pv on pvl.Product_Variant1_Id = pv.Product_Variant_Id
left join Product_Variant pv1 on pvl.Product_Variant2_Id = pv1.Product_Variant_Id
join #upcomingProductList up on p.Product_Id = up.Product_Id
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.Position = 1
left join discountOffer do on b.Business_Id = do.Business_Id 
						and (do.Product_Id is null or do.Product_Id = p.Product_Id)
left join coupon c on b.Business_Id = c.Business_Id 
						and (c.Product_Id is null or c.Product_Id = p.Product_Id)
left join Product_Category pc on p.Product_Category_Id = pc.Product_Category_Id
where b.Is_Active = 'Y'
and pvl.status = 'active'
and (pc.Name is null or  UPPER(pc.Name) <> 'TIP')
order by up.Created_Date desc


insert into #list
select p.Business_Id BusinessId
	    ,p.Product_Description ProductDescription
	    ,p.Product_Name ProductName 
	    ,p.Product_Id ProductId
	    ,p.productvid ProductVideoId
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
		,dateadd(month,-1, GETDATE()) CreatedDate
	    ,pvl.Price DiscountedPrice
	    ,0 IsDiscountAvailable
	    ,null DiscountPercentage
	    ,pc.Name ProductCategory
		,0 IsCouponAvailable
from Product p 
join Business b on p.Business_Id = b.Business_Id
join product_variant_list pvl on p.Product_Id = pvl.Product_Id
left join Product_Variant pv on pvl.Product_Variant1_Id = pv.Product_Variant_Id
left join Product_Variant pv1 on pvl.Product_Variant2_Id = pv1.Product_Variant_Id
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.Position = 1
left join Product_Category pc on p.Product_Category_Id = pc.Product_Category_Id
where UPPER(pc.Name) = 'TIP' and @shortname <> 'italybestcoffee' and @shortname <> 'istream'

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
	  ,Price
	  ,p.CreatedDate
	  ,DiscountedPrice
	  ,IsDiscountAvailable
	  ,DiscountPercentage
	  ,ProductCategory
	  ,IsCouponAvailable
	  ,@shippingDetail ShippingDetail
from  #list p
where rn = 1
order by p.CreatedDate desc

select pi.Product_Id ProductId
      ,pi.Image_Url ProductImage
	  ,pi.Product_Image_Id ProductImageId
	  ,pi.Desktop_Image_Url DesktopImageUrl
	  ,pi.Mobile_Image_Url MobileImageUrl
	  ,pi.Tablet_Image_Url TabletImageUrl
from Product p
join Product_Image pi on p.Product_Id = pi.Product_Id
join #upcomingProductList up on p.Product_Id = up.Product_Id

UNION

select pi.Product_Id ProductId
      ,pi.Image_Url ProductImage
	  ,pi.Product_Image_Id ProductImageId
	  ,pi.Desktop_Image_Url DesktopImageUrl
	  ,pi.Mobile_Image_Url MobileImageUrl
	  ,pi.Tablet_Image_Url TabletImageUrl
from Product p
join Product_Image pi on p.Product_Id = pi.Product_Id
join Product_Category pc on p.Product_Category_Id = pc.Product_Category_Id
where UPPER(pc.Name) = 'TIP' and @shortname <> 'italybestcoffee'

select pd.Product_Id ProductId
      ,pd.Price Amount
	  ,pd.Interval 
	  ,pd.Interval_Count IntervalCount
	  ,pd.Stripe_Price_Id StripePriceId
	  ,pd.Subscription_Name SubscriptionName
	  ,pd.Product_Variant_List_Id ProductVariantListId
from Product p
join Subscription_Price pd on p.Product_Id = pd.Product_Id
join Product_Variant_List pvl on pd.Product_Variant_List_Id = pvl.Product_Variant_List_Id
join #productList up on p.Product_Id = up.Product_Id
where pd.Is_Active = 1
and pvl.status = 'active'

create table #pollinfo(ProductId decimal(10),Poll nvarchar(max))

insert into #pollinfo
select pi.Product_Id ,pi.Poll_Info_Detail
from Poll_Info [pi]
where pi.Unique_Id = @upcomingUniqueId
and pi.Poll_Type = 2 

insert into #pollinfo
select up.Product_Id,up.Poll_Info_Detail
from Upcoming_Live_Stream ul
join Upcoming_Poll_Info up on ul.Media_Unique_Id = up.Upcoming_Unique_Id
where ul.Media_Unique_Id = @upcomingUniqueId
and up.Poll_Type = 2 and Is_Poll_Posted = 0

select vi.Product_Id,
	  vc.Channel_Id
	  ,vi.Poll_Type
	  ,vi.Ques_Desc 
	  ,vi.Ques_Options
	  ,p.Product_Name 
	  ,pi.Image_Url 
	  ,p.Product_Description 
	  ,pvl.Price
	  ,vi.Video_Interactivity_Id
	  ,vi.Poll_Time  
	  ,vc.Video_Unique_Id
	  into #videointeractivity
from Video_Channel vc
join Video_Interactivity vi on vc.Video_Channel_Id = vi.Video_Channel_Id
left join Product p on vi.Product_Id = p.Product_Id
left join Product_Variant_List pvl on p.Product_Id = pvl.Product_Id and pvl.Position = 1
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.Position = 1
where vc.Video_Unique_Id = @upcomingUniqueId

select p.Product_Name 
	  ,pi.Image_Url 
	  ,p.Product_Description 
	  ,pvl.Price
	  ,p.Product_Id
	  ,ci.Channel_Id
INTO #tipProduct
from Product p
join Business b on p.Business_Id = b.Business_Id
join Channel_Info ci on b.Business_Id = ci.Business_Id
left join Product_Variant_List pvl on p.Product_Id = pvl.Product_Id and pvl.Position = 1
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.Position = 1
left join Product_Category pc on p.Product_Category_Id = pc.Product_Category_Id
where UPPER(pc.Name) = 'TIP' and @shortname <> 'italybestcoffee'

insert into #pollinfo
SELECT  S.Product_Id ProductId ,
	cast((select Product_Id as 'ProductId' ,
	  Channel_Id as 'ChannelId'
	  ,Poll_Type as 'Type'
	  ,Ques_Desc as 'Description'
	  ,Ques_Options as 'Options'
	  ,Product_Id as 'Item.ItemId'
	  ,Product_Name as 'Item.Name'
	  ,Image_Url as 'Item.ItemUrl'
	  ,Poll_Type as 'Item.Type'
	  ,product_Description  as 'Item.Description'
	  ,Price as 'Item.Price'
	  ,0 as 'Item.Quantity'
	  ,Video_Interactivity_Id  as 'PollInfoId'
	  ,Poll_Time  as 'PollElapsedTime'
	  ,Video_Unique_Id as 'PollUniqueId'
from #videointeractivity 
 WHERE Video_Interactivity_Id = S.Video_Interactivity_Id
FOR JSON PATH, INCLUDE_NULL_VALUES,WITHOUT_ARRAY_WRAPPER) as nvarchar(max))Poll_Info_Detail	
FROM #videointeractivity S;

insert into #pollinfo
SELECT  S.Product_Id ProductId ,
	cast((select Product_Id as 'ProductId' ,
	  Channel_Id as 'ChannelId'
	  ,2 as 'Type'
	  ,null as 'Description'
	  ,null as 'Options'
	  ,Product_Id as 'Item.ItemId'
	  ,Product_Name as 'Item.Name'
	  ,Image_Url as 'Item.ItemUrl'
	  ,2 as 'Item.Type'
	  ,product_Description  as 'Item.Description'
	  ,Price as 'Item.Price'
	  ,0 as 'Item.Quantity'
	  ,1 as 'PollInfoId'
	  ,1 as 'PollElapsedTime'
	  ,@upcomingUniqueId as 'PollUniqueId'
from #tipProduct 
 WHERE Product_Id = S.Product_Id
FOR JSON PATH, INCLUDE_NULL_VALUES,WITHOUT_ARRAY_WRAPPER) as nvarchar(max))Poll_Info_Detail	
FROM #tipProduct S;

select * 
from #pollinfo

select business_payment_method_id BusinessPaymentMethodId 
	  ,Payment_Method PaymentMethod
	  ,Sort_Order sortorder
	  ,Payment_Integration PaymentIntegration
from Business_payment_methods
where business_id = @businessId

select * from 
(select pr.Product_Id ProductId
	  ,'' ReviewTitle
      ,pr.Review_Detail  ReviewDetail
	  ,pr.Review_Rating ReviewRating
	  ,pr.UserId
	  ,ISNULL(u.UserName,User_Name) UserName
	  ,ISNULL(u.ImageUrl,'') User_Profile_Image
	  ,0 BusinessId
from Product p
join Product_Review pr on p.Product_Id = pr.Product_Id
left join AspNetUsers u on pr.UserId = u.Id
where p.Business_Id = @businessId
and (p.Product_Category_Id = @productCategoryId or @productCategoryId is null) and p.status = 'active'

UNION 

select 0 ProductId
	  ,Review_Title ReviewTitle
	  ,cast(Review_Detail as varchar(max)) ReviewDetail
	  ,Review_Rating ReviewRating
	  ,'' UserId
	  ,User_Name UserName
	  ,'' User_Profile_Image
	  ,Business_Id BusinessId
from Business_Review
where Business_Id =@businessId) review

drop table #list
drop table #pollinfo
drop table #upcomingProductList
drop table #productList

END;