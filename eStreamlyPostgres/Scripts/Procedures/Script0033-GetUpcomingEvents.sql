CREATE PROCEDURE [dbo].[GetUpcomingEvents](@liveUniqueId varchar(250))
AS
BEGIN

DECLARE @query nvarchar(max) = '';

create table #upcomingevent(
Upcoming_Live_Stream_Id [bigint] NOT NULL,
Name [nvarchar](250) NULL,
Description [nvarchar](250) NULL,
ChannelId [nvarchar](250) NOT NULL,	
Media_Unique_Id [nvarchar](250) NULL,
[StartDateTime] datetime not null,
[EndDateTime] datetime null,
User_Id [nvarchar](250) NOT NULL,
EventImage [nvarchar](max)  NULL,	
DesktopImageUrl [nvarchar](250) NULL,
MobileImageUrl [nvarchar](250) NULL,
TabletImageUrl [nvarchar](500) NULL,
User_Profile_Image [nvarchar](500) NULL,
User_Thumbnail_Image [nvarchar](500) NULL,
BusinessName [nvarchar](250)  NULL,
BusinessImage [nvarchar](max)  NULL,
BackgroundImage [nvarchar](max)  NULL,
ChannelName [nvarchar](250)  NULL,
MerchantShortName [nvarchar](max)  NULL,
EventName [nvarchar](max)  NULL,
EventDesc [nvarchar](max)  NULL,
Business_Id [bigint] NOT NULL,	
)

INSERT INTO #upcomingevent
select ul.Upcoming_Live_Stream_Id
	    ,ul.Name
	    ,ul.Description Description
	    ,ul.Channel_Id ChannelId
	    ,ul.Media_Unique_Id
	    ,ul.Start_Date_Time StartDateTime
	    ,ul.End_Date_Time EndDateTime
	    ,ul.User_Id
	    ,ul.Event_Image EventImage
	    ,ul.Desktop_Image_Url DesktopImageUrl
	    ,ul.Mobile_Image_Url MobileImageUrl
	    ,ul.Tablet_Image_Url TabletImageUrl
	    ,u.ImageUrl User_Profile_Image
	    ,u.ThumbnailImageUrl User_Thumbnail_Image
		,b.Business_Name BusinessName 
		,b.Business_Image BusinessImage
		,b.Background_Image BackgroundImage
		,ci.Channel_Name ChannelName
		,b.Shortname MerchantShortName
		,ul.Name EventName
		,ul.Description EventDesc
		,b.Business_Id
--INTO #upcomingevent
from Upcoming_Live_Stream ul
join Channel_Info ci on ul.channel_id = ci.channel_id
join business b on ci.Business_Id = b.Business_Id
left join AspNetUsers u on ul.User_Id = u.Id
where ul.Media_Unique_Id = @liveUniqueId

create table #userChannel(
ChannelInfoId [bigint] NOT NULL,
ChannelId [nvarchar](250) NOT NULL,		
UserId [nvarchar](250) NOT NULL,
BusinessId [bigint] NOT NULL,		
ChannelDesc [nvarchar](250) NULL,
ChannelName [nvarchar](250) NULL,
ImageUrl [nvarchar](500) NULL,
ThumbnailImageUrl [nvarchar](500) NULL,
BusinessName [nvarchar](250)  NULL,
BusinessImage [nvarchar](max)  NULL,
BackgroundImage [nvarchar](max)  NULL,
LiveUniqueId [nvarchar](250)  NULL,
EventName [nvarchar](max)  NULL,
EventDesc [nvarchar](max)  NULL,
EventImage [nvarchar](max)  NULL,
Shortname [nvarchar](250)  NULL,
BusinessDescription [nvarchar](250)  NULL,
BusinessUrl [nvarchar](250)  NULL
)

select @query = @query + 'EXEC GetUserChannel null,null,'+ Convert(varchar,Business_Id) + ';'
from #upcomingevent

insert into #userChannel
	EXEC (@query);

select e.Upcoming_Live_Stream_Id
	    ,e.Name
	    ,e.Description Description
	    ,e.Channel_Id ChannelId
	    ,e.Media_Unique_Id
	    ,e.Start_Date_Time StartDateTime
	    ,e.End_Date_Time EndDateTime
	    ,e.User_Id
	    ,e.Event_Image EventImage
	    ,e.Desktop_Image_Url DesktopImageUrl
	    ,e.Mobile_Image_Url MobileImageUrl
	    ,e.Tablet_Image_Url TabletImageUrl
	    ,u.ImageUrl User_Profile_Image
	    ,u.ThumbnailImageUrl User_Thumbnail_Image
		,uc.BusinessName 
		,uc.BusinessImage
		,uc.BackgroundImage
		,uc.ChannelName
		,uc.Shortname MerchantShortName
		,e.name EventName
		,e.Description EventDesc
		,e.Event_Video_Url EventVideoUrl
		,e.Event_Video_Gif_Url EventVideoGifUrl
from Upcoming_Live_Stream e
join #userChannel uc on e.Channel_Id = uc.ChannelId
left join AspNetUsers u on e.User_Id = u.Id
left join Live_Stream_Info li on e.Media_Unique_Id = ISNULL(li.Upcoming_Unique_Id,li.Unique_Id)
where e.media_unique_id != @liveUniqueId
and Start_Date_Time >= GETUTCDATE()
and e.Is_Private_Event = 0
and (li.Live_Stream_Info_Id is null or li.Live_Stream_Info_Id = 0)
order by e.Start_Date_Time

select  0 IsLive
	    ,ci.Channel_Id ChannelId
	    ,ci.Channel_Name ChannelName
	    ,m.Media_Item_Id
	    ,m.User_Id [User_Id]
	    ,m.Media_Url Media_Url 
	    ,m.Media_thumbnail_Url  Media_thumbnailUrl
	    ,m.Media_thumbnailGif_Url Media_thumbnailGifUrl
	    ,m.CreatedDate
	    ,u.ImageUrl User_Profile_Image
	    ,u.ThumbnailImageUrl User_Thumbnail_Image
	    ,m.Channel_Desc ChannelDesc
	    ,m.Media_Unique_Id Video_Id
	    ,0 IsUpcomingLiveStream
	    ,'media' MediaType	  
	    ,b.Business_Name BusinessName
	    ,b.Business_Image BusinessImage
	    ,b.Background_Image BackgroundImage
	    ,b.Shortname MerchantShortName
	    ,m.Desktop_Image_Url DesktopImageUrl
	    ,m.Mobile_Image_Url MobileImageUrl
	    ,m.Tablet_Image_Url TabletImageUrl	
		,m.Channel_Name EventName
		,m.Channel_Desc EventDesc
from MediaByUserAndChannel m
join Live_Stream_Info ls on m.Media_Unique_Id = ls.Unique_Id
join Channel_Info ci on ls.Channel_Info_Id = ci.Channel_Info_Id 
join Business b on ci.Business_Id = b.Business_Id
join AspNetUsers u on m.User_Id = u.Id
join #userChannel uc on b.Business_Id = uc.BusinessId
left join Upcoming_Live_Stream ul on m.Media_Unique_Id = ul.Media_Unique_Id
where b.Is_Active = 'Y'
and (ul.Is_Private_Event = 0 or ul.Is_Private_Event is null)
and (ul.Upcoming_Live_Stream_Id is null or (ul.Upcoming_Live_Stream_Id is not null and (ul.End_Date_Time is null or ul.End_Date_Time < GETDATE())))
and ul.Is_Active = 'Y'
order by m.CreatedDate desc

--;with discountOffer as (
select do.*
	  ,ROW_NUMBER() OVER (partition by product_id order by created_date desc) rn
INTO #discountOffer
from Discount_Offer do
join #upcomingevent bl on do.Business_Id = bl.Business_Id
where GETDATE()  between valid_start_date and valid_end_date
--)

select BusinessId
	  ,ProductDescription
	  ,ProductName
	  ,ProductId
	  ,ProductVideoId
	  ,ProductImage
	  ,DesktopImageUrl
	  ,MobileImageUrl
	  ,TabletImageUrl
	  ,Price
	  ,ISNULL(DiscountedPrice,Price) DiscountedPrice
	  ,IsDiscountAvailable
	  ,ISNULL(DiscountPercentage,0) DiscountPercentage
from (
select p.Business_Id BusinessId
	    ,p.Product_Description ProductDescription
	    ,p.Product_Name ProductName 
	    ,p.Product_Id ProductId
	    ,p.productvid ProductVideoId
	    ,pi.Image_Url ProductImage
		,pi.Desktop_Image_Url DesktopImageUrl
		,pi.Mobile_Image_Url MobileImageUrl
		,pi.Tablet_Image_Url TabletImageUrl
		,pvl.Price
	    ,ROW_NUMBER() OVER (PARTITION BY p.product_id ORDER BY pi.Created_Date ) AS rn
		,cast (pvl.Price  - (pvl.Price  * do.Discount_Percentage / 100) as decimal(10,2)) DiscountedPrice
		,CASE WHEN do.Discount_Percentage > 0 THEN 1 ELSE 0 END IsDiscountAvailable
		,do.Discount_Percentage DiscountPercentage
from Product p 
join #upcomingevent b on p.Business_Id = b.Business_Id
join Product_Variant_List pvl on p.Product_Id = pvl.Product_Id
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.position = 1
left join #discountOffer do on b.Business_Id = do.Business_Id and (do.product_id is null or do.product_id = p.Product_Id)
where p.Status = 'active' and (do.rn = 1 or rn is null)) p
where rn = 1 

select * 
from #upcomingevent

select f.Business_Id BusinessId
	  ,f.Influencer_Id InfluencerId
	  ,f.UserId UserId
	  ,us.FullName UserName
	  ,us.ImageUrl User_Profile_Image
	  ,us.ThumbnailImageUrl User_Thumbnail_Image
from Follower f
join #upcomingevent u on f.business_id = u.business_id
join aspnetusers us on f.userid = us.id

select  * 
from #userChannel

select ISNULL(sum(ls.Like_Count),0) LikeCount
from Live_Stream_Info ls
join Upcoming_Live_Stream ul on ls.Unique_Id = ul.Media_Unique_Id
join channel_info ci on ls.Channel_Info_Id = ci.Channel_Info_Id
join Business b on ci.Business_Id = b.Business_Id
join #userChannel uc on b.Business_Id = uc.BusinessId
where ul.Is_Private_Event = 0
group by b.Business_Id

select (select Count(*) TotalPost 
		from MediaByUserAndChannel m
		join Upcoming_Live_Stream ul on m.Media_Unique_Id = ul.Media_Unique_Id 
		join Live_Stream_Info ls on ul.Media_Unique_Id = ls.Unique_Id
		join Channel_Info ci on ls.Channel_Info_Id = ci.Channel_Info_Id
		join Business b on ci.Business_Id = b.Business_Id
		join #userChannel uc on b.Business_Id = uc.BusinessId
		where ul.Is_Private_Event = 0 and ul.Is_Active = 'Y') 
		+
		(select Count(*) TotalPost
		from Video_Channel vc 
		join Business b on vc.Business_Id = b.Business_Id
		join #userChannel uc on b.Business_Id = uc.BusinessId
		where vc.Is_Active = 1) TotalPost

drop table #upcomingevent
drop table #userChannel
END