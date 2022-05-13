CREATE PROCEDURE [dbo].[GetProductListById](@productId bigint)
AS
BEGIN

--DECLARE @productId bigint = 19;
Declare @businessId decimal(10);--,@productCategoryId decimal(10)

select @businessId = Business_Id 
from Product p
where p.Product_Id = @productId;

with discountOffer as (
select *
	  ,ROW_NUMBER() over(partition by do.product_id order by do.created_date desc) rn
from Discount_Offer do
where Business_id = @businessId
and GETDATE()  between valid_start_date and valid_end_date
), coupon as 
(
select * 
from Discount_Coupon dc
where Business_Id = @businessId
--and GETDATE() between Valid_Start_Date and Valid_End_Date\
and ( GETDATE()  between Valid_Start_Date and Valid_End_Date)
)

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
	  ,ISNULL(DiscountedPrice,Price) DiscountedPrice
	  ,IsDiscountAvailable
	  ,DiscountPercentage
	  ,Note
	  ,Position
	  ,ProductCategory
	  ,IsCouponAvailable
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
		,p.Note
		,pvl.Position
		,pc.Name ProductCategory
		,CASE WHEN c.Discount_Percentage > 0 THEN 1 ELSE 0 END IsCouponAvailable
from Product p 
join Business b on p.Business_Id = b.Business_Id
join product_variant_list pvl on p.Product_Id = pvl.Product_Id
left join Product_Variant pv on pvl.Product_Variant1_Id = pv.Product_Variant_Id
left join Product_Variant pv1 on pvl.Product_Variant2_Id = pv1.Product_Variant_Id
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.position = 1
left join Product_Video pvi on p.Product_Id = pvi.Product_Id
left join discountOffer do on b.Business_Id = do.Business_Id and (do.product_id is null or do.product_id = p.Product_Id)  and (do.rn is null or do.rn = 1)
left join Product_Category pc on p.Product_Category_Id = pc.Product_Category_Id
left join coupon c on b.Business_Id = c.Business_Id 
						and (c.Product_Id is null or c.Product_Id = p.Product_Id)
where p.Product_Id = @productId and p.status = 'active') p
where rn = 1
ORDER BY NEWID(),p.ProductId,p.Position

select pd.Product_Id ProductId
      ,pd.Description
	  ,pd.Name
	  ,pd.Product_Detail_Id
from Product p
join Product_Detail pd on p.Product_Id = pd.Product_Id
where p.Product_Id = @productId and p.status = 'active'

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
where p.Product_Id = @productId and p.status = 'active'

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

select pi.Product_Id ProductId
      ,pi.Image_Url ProductImage
	  ,pi.Product_Image_Id ProductImageId
	  ,pi.Desktop_Image_Url DesktopImageUrl
	  ,pi.Mobile_Image_Url MobileImageUrl
	  ,pi.Tablet_Image_Url TabletImageUrl
from Product p
join Product_Image pi on p.Product_Id = pi.Product_Id
where p.Business_Id = @businessId
and (p.Product_Id = @productId) and p.status = 'active'

select pd.Product_Id ProductId
      ,pd.Answer
	  ,pd.Product_Ques_Ans_Id ProductQuesAnsId
	  ,pd.QuesPostedUserId QuesPostedUserId
	  ,pd.Question 
	  ,u.UserName
from Product p
join Product_Ques_Ans pd on p.Product_Id = pd.Product_Id
join AspNetUsers u on pd.QuesPostedUserId = u.Id
where p.Business_Id = @businessId
and (p.Product_Id = @productId) and p.status = 'active'

select p.Product_Id ProductId
      ,pd.Product_Shipping_Id ProductShippingDetailId
	  ,pd.Return_Detail ReturnDetail
	  ,pd.Shipping_Detail ShippingDetail
	  ,CASE WHEN pd.Max_Order_Amount > 0 and pd.Shipping_Amount > 0 THEN 'Free US standard shipping for orders valued at $'+ cast(pd.Max_Order_Amount as varchar(50))+' or more </br> $' + cast(pd.Shipping_Amount as varchar(50))+' Standard Flat Rate Shipping' 
		WHEN pd.Max_Order_Amount > 0 THEN 'Free US standard shipping for orders valued at $'+ cast(pd.Max_Order_Amount as varchar(50))+' or more </br>' 
		WHEN pd.shipping_amount > 0 THEN '$' + cast(pd.Shipping_Amount as varchar(50))+' Standard Flat Rate Shipping' 
	  ELSE '' 
	  END ShippingSummary
from Product p
join Product_Shipping_Detail pd on p.Business_Id = pd.Business_Id
where p.Business_Id = @businessId
and (p.Product_Id = @productId) and p.status = 'active'

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
where p.Business_Id = @businessId
and (p.Product_Id = @productId) and p.status = 'active'
and pd.Is_Active = 1

select f.Business_Id BusinessId
      ,f.Influencer_Id InfluencerId
	  ,f.UserId
	  ,u.UserName 
	  ,u.ImageUrl User_Profile_Image
	  ,u.ThumbnailImageUrl User_Thumbnail_Image
from Follower f
join AspNetUsers u on f.UserId = u.Id
where f.Business_Id = @businessId

select pi.Product_Id ProductId
      ,pi.Video_Url ProductVideo
	  ,pi.Product_Video_Id ProductVideoId
from Product p
join Product_Video pi on p.Product_Id = pi.Product_Id
where p.Business_Id = @businessId
and (p.Product_Id = @productId) and p.status = 'active'

END;