CREATE PROCEDURE [dbo].[GetUserChannel](
 @channelId varchar(500),
@channelInfoId bigint,
@businessId	bigint 
)
AS
BEGIN

CREATE TABLE #liveStream(Channel_Info_Id bigint not null,
						 Unique_Id nvarchar(250),
						 rn bigint,
						 EventImage varchar(1000),
						 EventDesc varchar(1000),
						 EventName varchar(1000),
						 DesktopImageUrl varchar(1000)
						 )

INSERT INTO #liveStream
select ls.Channel_Info_Id
	  ,ls.Unique_Id
	  ,ROW_NUMBER() OVER (PARTITION BY ls.Channel_Info_Id ORDER BY ls.Created_Date desc ) AS rn	  
	  ,ul.Event_Image EventImage 
	  ,ul.Description EventDesc
	  ,ul.Name EventName
	  ,ul.Desktop_Image_Url DesktopImageUrl
from Live_Stream_Info ls
join Channel_Info ci on ls.Channel_Info_Id = ci.Channel_Info_Id
left join Upcoming_Live_Stream ul on ls.Unique_Id = ul.Media_Unique_Id
where (ci.Channel_Id = @channelId or @channelId is null)
and (ci.Channel_Info_Id = @channelInfoId or @channelInfoId is null)
and (ci.Business_Id = @businessId or @businessId is null)
group by ls.Channel_Info_Id
		,Unique_Id 
		,ls.Created_Date
		,ul.Event_Image 
		,ul.Description
		,ul.Name 
		,ul.Desktop_Image_Url

;with  userChannel as (
select  ci.Channel_Id,
		ci.Channel_Info_Id,
		ci.Business_Id,
		uc.UserId,
		r.Name,
		ci.Channel_Name,
		ci.Channel_Desc,
		b.Business_Image ImageUrl,
		b.Background_Image ThumbnailImageUrl,
		b.Business_Name,
		b.Business_Image,
		b.Background_Image,
	    CASE WHEN  r.Name like 'Channel Owner' THEN 1
		     WHEN r.Name like 'Admin' THEN 2 END RoleNo,
	    ROW_NUMBER() OVER (PARTITION BY ci.Channel_info_id ORDER BY ci.Channel_info_id) AS rn,
		ls.Unique_Id,
		ls.EventName,
		ls.EventDesc,
		ls.EventImage,
		b.Shortname,
		ls.DesktopImageUrl,
		b.Business_Description BusinessDescription,
		b.Business_Url BusinessUrl	
--INTO #userChannel
from Channel_Info ci
join Business b on ci.Business_Id = b.Business_Id
left join User_Channel uc on ci.Channel_Info_Id = uc.Channel_Info_Id
left join AspNetUserRoles ur on uc.UserId = ur.UserId
left join AspNetRoles r on ur.RoleId = r.Id
left join AspNetUsers u on uc.UserId = u.Id
left join #liveStream ls on ci.Channel_Info_Id = ls.Channel_Info_Id and ls.rn = 1
WHERE r.Name in('Channel Owner','Admin') or r.Name is null or r.Name = ''
)
--select * from #userChannel

select Channel_Info_Id ChannelInfoId,
		Channel_Id ChannelId,		
		UserId,
		Business_Id BusinessId,		
		Channel_Desc ChannelDesc,
		Channel_Name ChannelName,
		imageUrl ImageUrl,
		ThumbnailImageUrl ThumbnailImageUrl,
	    Business_Name BusinessName,
	    Business_Image BusinessImage,
		Background_Image BackgroundImage,
		Unique_Id LiveUniqueId,
		EventName,
		EventDesc,
		EventImage,
		Shortname,
		BusinessDescription,
		BusinessUrl
from userChannel
where rn = 1 
and (Channel_Id = @channelId or @channelId is null)
and (Channel_Info_Id = @channelInfoId or @channelInfoId is null)
and (Business_Id = @businessId or @businessId is null)
group by  Channel_Id,
		Channel_Info_Id,
		Business_Id,
		UserId,
		Name,
		Channel_Name,
		Channel_Desc,
		imageUrl,
		ThumbnailImageUrl,
	    Business_Name,
	    Business_Image,
		Background_Image,
		RoleNo,
		Unique_Id,
		EventName,
		EventDesc,
		EventImage,
		Shortname,
		BusinessDescription,
		BusinessUrl
order by Channel_Id,RoleNo 

--drop table #userChannel
drop table #liveStream
END;