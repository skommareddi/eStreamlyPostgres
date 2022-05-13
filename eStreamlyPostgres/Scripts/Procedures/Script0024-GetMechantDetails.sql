CREATE PROCEDURE [dbo].[GetMechantDetails] (
@shortName varchar(100) )
AS
BEGIN
--declare @shortName varchar(100) = 'bulkhomme'
DECLARE @query nvarchar(max) = '';

create table #businessList(
[Business_Id] [bigint] NOT NULL,
	[UserName] [nvarchar](250) NOT NULL,
	[Business_Name] [nvarchar](250) NOT NULL,
	[Business_Description] [nvarchar](max) NULL,
	[Business_Url] [nvarchar](500) NULL,
	[Business_Image] [nvarchar](1000) NULL,
	[User_Id] [varchar](250) NULL,
	[Shortname] [nvarchar](250) NULL,
	[Background_Image] [nvarchar](1000) NULL,
)

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
EventImage [nvarchar](250)  NULL,
Shortname [nvarchar](250)  NULL
)

insert into #businessList
select Business_Id
	  ,UserName
	  ,Business_Name
	  ,Business_Description
	  ,Business_Url
	  ,Business_Image
	  ,User_Id
	  ,Shortname
	  ,Background_Image
from Business b 
where Shortname = @shortName
and Is_Active = 'Y'

insert into #businessList
select b.Business_Id
	  ,b.UserName
	  ,Business_Name
	  ,Business_Description
	  ,Business_Url
	  ,Business_Image
	  ,b.User_Id
	  ,Shortname
	  ,Background_Image
from channel_info c
join Business b on c.Business_Id = b.Business_Id
join User_Channel uc on c.Channel_Info_Id = uc.Channel_Info_Id
join AspNetUsers u on uc.UserId = u.Id
where u.UserShortName = @shortName
and Is_Active = 'Y'

--select * from #businessList
--select @query = @query + 'EXEC GetUserChannel null,null,'+ Convert(varchar,Business_Id) + ';'
--from #businessList

select ls.Channel_Info_Id
	  ,ls.Unique_Id
	  ,ROW_NUMBER() OVER (PARTITION BY ls.Channel_Info_Id ORDER BY ls.Created_Date desc ) AS rn	  
	  ,ul.Event_Image EventImage 
	  ,ul.Description EventDesc
	  ,ul.Name EventName
INTO #liveStream
from Live_Stream_Info ls
left join Upcoming_Live_Stream ul on ls.Unique_Id = ul.Media_Unique_Id
group by Channel_Info_Id
		,Unique_Id 
		,ls.Created_Date
		,ul.Event_Image 
		,ul.Description
		,ul.Name 

select  ci.Channel_Id,
		ci.Channel_Info_Id,
		ci.Business_Id,
		uc.UserId,
		r.Name,
		ci.Channel_Name,
		ci.Channel_Desc,
		u.ImageUrl,
		u.ThumbnailImageUrl,
		b.Business_Name,
		b.Business_Image,
		b.Background_Image,
	    CASE WHEN  r.Name like 'Channel Owner' THEN 1
		     WHEN r.Name like 'Admin' THEN 2 END RoleNo,
	    ROW_NUMBER() OVER (PARTITION BY ci.channel_id ORDER BY ci.channel_id ) AS rn,
		ls.Unique_Id,
		ls.EventName,
		ls.EventDesc,
		ls.EventImage,
		b.Shortname
INTO #userChannels
from Channel_Info ci
join Business b on ci.Business_Id = b.Business_Id
join User_Channel uc on ci.Channel_Info_Id = uc.Channel_Info_Id
join AspNetUserRoles ur on uc.UserId = ur.UserId
join AspNetRoles r on ur.RoleId = r.Id
join AspNetUsers u on uc.UserId = u.Id
left join #liveStream ls on ci.Channel_Info_Id = ls.Channel_Info_Id and ls.rn = 1
WHERE r.Name in('Channel Owner','Admin')
and Is_Active = 'Y'

insert into #userChannel
select uc.Channel_Info_Id ChannelInfoId,
		uc.Channel_Id ChannelId,		
		uc.UserId,
		uc.Business_Id BusinessId,		
		uc.Channel_Desc ChannelDesc,
		uc.Channel_Name ChannelName,
		uc.imageUrl ImageUrl,
		uc.ThumbnailImageUrl ThumbnailImageUrl,
	    uc.Business_Name BusinessName,
	    uc.Business_Image BusinessImage,
		uc.Background_Image BackgroundImage,
		uc.Unique_Id LiveUniqueId,
		uc.EventName,
		uc.EventDesc,
		uc.EventImage,
		uc.Shortname
from #userChannels uc 
join #businessList bl on uc.Business_Id = bl.Business_Id
where rn = 1 
group by  Channel_Id,
		Channel_Info_Id,
		uc.Business_Id,
		UserId,
		Name,
		Channel_Name,
		Channel_Desc,
		imageUrl,
		ThumbnailImageUrl,
	    uc.Business_Name,
	    uc.Business_Image,
		uc.Background_Image,
		RoleNo,
		Unique_Id,
		EventName,
		EventDesc,
		EventImage,
		uc.Shortname
--insert into #userChannel
--	EXEC (@query);

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
from Upcoming_Live_Stream e
join #userChannel uc on e.Channel_Id = uc.ChannelId
left join AspNetUsers u on e.User_Id = u.Id
left join Live_Stream_Info li on e.Media_Unique_Id = ISNULL(li.Upcoming_Unique_Id,li.Unique_Id)
where Start_Date_Time >= GETUTCDATE()
and e.Is_Private_Event = 0
and (li.Live_Stream_Info_Id is null or li.Live_Stream_Info_Id = 0)
order by e.Start_Date_Time

select * from 
	(select  0 IsLive
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

	UNION 
	select  0 IsLive
			,ci.Channel_Id ChannelId
			,ci.Channel_Name ChannelName
			,m.Video_Channel_Id Media_Item_Id
			,m.User_Id [User_Id]
			,m.Video_Url Media_Url 
			,m.Video_Thumbnail_Url Media_thumbnailUrl
			,m.Video_Gif_Url Media_thumbnailGifUrl
			,m.Created_Date
			,u.ImageUrl User_Profile_Image
			,u.ThumbnailImageUrl User_Thumbnail_Image
			,m.Description ChannelDesc
			,m.Video_Unique_Id Video_Id
			,0 IsUpcomingLiveStream
			,'media' MediaType
			,b.Business_Name BusinessName
			,b.Business_Image BusinessImage
			,b.Background_Image BackgroundImage
			,b.Shortname MerchantShortName
			,m.Desktop_Thumbnail_Url DesktopImageUrl
			,m.Mobile_Thumbnail_Url MobileImageUrl
			,m.Tablet_Thumbnail_Url TabletImageUrl	
			,m.Title EventName
			,m.Description EventDesc
	from Video_Channel m
	join Channel_Info ci on m.Channel_Id= ci.Channel_Id
	join Business b on ci.Business_Id = b.Business_Id
	join AspNetUsers u on m.User_Id = u.Id
	join #userChannel uc on b.Business_Id = uc.BusinessId
	where b.Is_Active = 'Y'
	and m.Is_Active = 1
	) s
order by CreatedDate desc;


with discountOffer as (
select do.*
	  ,ROW_NUMBER() over(partition by do.product_id order by do.created_date desc) rn
from Discount_Offer do
join #businessList bl on do.Business_Id = bl.Business_Id
where GETDATE()  between valid_start_date and valid_end_date
)

select BusinessId
	  ,ProductDescription
	  ,ProductName
	  ,ProductId
	  ,ProductVideoId
	  ,ProductImage
	  ,Price
	  ,DesktopImageUrl
	  ,MobileImageUrl
	  ,TabletImageUrl
	  ,Review
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
		,pvl.Price
	    ,ROW_NUMBER() OVER (PARTITION BY p.product_id ORDER BY pi.Created_Date ) AS rn
		,pi.desktop_image_url DesktopImageUrl
		,pi.mobile_image_url MobileImageUrl
		,pi.Tablet_Image_Url TabletImageUrl
		,pr.Review
		,cast (pvl.Price  - (pvl.Price  * do.Discount_Percentage / 100) as decimal(10,2)) DiscountedPrice
		,CASE WHEN do.Discount_Percentage > 0 THEN 1 ELSE 0 END IsDiscountAvailable
		,do.Discount_Percentage DiscountPercentage
from Product p 
join #businessList b on p.Business_Id = b.Business_Id
join Product_Variant_List pvl on p.Product_Id = pvl.Product_Id
left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.Position = 1
left join (select 0 BusinessId, pr.Product_Id ProductId
	  ,CAST(ROUND((SUM(pr.Review_Rating) / COUNT(pr.Product_Review_Id)),2) as numeric(10,2)) Review
from Product p
join Product_Review pr on p.Product_Id = pr.Product_Id
join #businessList b on p.business_id = b.business_id
where (p.status is null or p.status = 'active')
group by pr.product_id
UNION
select pr.Business_Id BusinessId
      ,0 ProductId
	  ,CAST(ROUND((SUM(pr.Review_Rating) / COUNT(pr.Business_Review_Id)),2) as numeric(10,2)) Review
from #businessList p
join Business_Review pr on p.business_id = pr.Business_Id
group by pr.Business_Id) pr on ( p.Product_Id = pr.ProductId or p.Business_Id = pr.BusinessId) 
left join discountOffer do on b.Business_Id = do.Business_Id and (do.product_id is null or do.product_id = p.Product_Id) and (do.rn is null or do.rn = 1)
where (p.status is null or p.status = 'active')
and pvl.status = 'active') p
where rn = 1

select ISNULL(sum(ls.Like_Count),0) LikeCount
from Live_Stream_Info ls
join Upcoming_Live_Stream ul on ls.Unique_Id = ul.Media_Unique_Id
join channel_info ci on ls.Channel_Info_Id = ci.Channel_Info_Id
join Business b on ci.Business_Id = b.Business_Id
where ul.Is_Private_Event = 0
and b.Shortname = @shortName
group by b.Business_Id


select (select Count(*) TotalPost 
		from MediaByUserAndChannel m
		join Upcoming_Live_Stream ul on m.Media_Unique_Id = ul.Media_Unique_Id 
		join Live_Stream_Info ls on ul.Media_Unique_Id = ls.Unique_Id
		join Channel_Info ci on ls.Channel_Info_Id = ci.Channel_Info_Id
		join Business b on ci.Business_Id = b.Business_Id
		where b.Shortname = @shortName
		and ul.Is_Private_Event = 0 and ul.Is_Active = 'Y') 
		+
		(select Count(*) TotalPost
		from Video_Channel vc 
		join Business b on vc.Business_Id = b.Business_Id
		where b.Shortname = @shortName
		and vc.Is_Active = 1) TotalPost

drop table #businessList
drop table #userChannel
drop table #liveStream
drop table #userChannels
END;