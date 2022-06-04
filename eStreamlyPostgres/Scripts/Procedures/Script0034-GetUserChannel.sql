CREATE OR REPLACE FUNCTION public.getuserchannel(
	channelid1 character varying,
	channelinfoid1 bigint,
	businessid1 bigint)
    RETURNS TABLE(ChannelInfoId bigint, 
				  ChannelId character varying,
				  UserId character varying,
				  BusinessId bigint, 
				  ChannelDesc character varying,
				  ChannelName character varying,
				  ImageUrl character varying,
				  ThumbnailImageUrl character varying,
				  BusinessName character varying,
				  BusinessImage character varying,
				  BackgroundImage character varying,
				  UniqueId character varying,
				  EventName character varying,
				  EventDesc character varying,
				  EventImage character varying,
				  Shortname character varying,
				  BusinessDescription character varying,
				  BusinessUrl character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	DECLARE 
     BEGIN
	 
DROP TABLE IF EXISTS liveStream;
CREATE TEMP TABLE liveStream(Channel_Info_Id bigint not null,
						 Unique_Id varchar(250),
						 rn bigint,
						 EventImage varchar(1000),
						 EventDesc varchar(1000),
						 EventName varchar(1000),
						 DesktopImageUrl varchar(1000)
						 );

INSERT INTO liveStream
select ls."Channel_Info_Id"
	  ,ls."Unique_Id"
	  ,ROW_NUMBER() OVER (PARTITION BY ls."Channel_Info_Id" ORDER BY ls."Created_Date" desc ) AS rn	  
	  ,ul."Event_Image" EventImage 
	  ,ul."Description" EventDesc
	  ,ul."Name" EventName
	  ,ul."Desktop_Image_Url" DesktopImageUrl
from "Live_Stream_Info" ls
join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
left join "Upcoming_Live_Stream" ul on ls."Unique_Id" = ul."Media_Unique_Id"
where (ci."Channel_Id" = channelid1 or channelid1 is null)
and (ci."Channel_Info_Id" = channelinfoid1 or channelinfoid1 is null)
and (ci."Business_Id" = businessid1 or businessid1 is null)
group by ls."Channel_Info_Id"
		,"Unique_Id" 
		,ls."Created_Date"
		,ul."Event_Image" 
		,ul."Description"
		,ul."Name" 
		,ul."Desktop_Image_Url";
		
	RETURN QUERY
	
with  userChannel as (
select  ci."Channel_Id",
		ci."Channel_Info_Id",
		ci."Business_Id",
		uc."UserId",
		r."Name",
		ci."Channel_Name",
		ci."Channel_Desc",
		b."Business_Image" ImageUrl,
		b."Background_Image" ThumbnailImageUrl,
		b."Business_Name",
		b."Business_Image",
		b."Background_Image",
	    CASE WHEN  r."Name" like 'Channel Owner' THEN 1
		     WHEN r."Name" like 'Admin' THEN 2 END RoleNo,
	    ROW_NUMBER() OVER (PARTITION BY ci."Channel_Info_Id" ORDER BY ci."Channel_Info_Id") AS rn,
		ls.Unique_Id,
		ls.EventName,
		ls.EventDesc,
		ls.EventImage,
		b."Shortname",
		ls.DesktopImageUrl,
		b."Business_Description" BusinessDescription,
		b."Business_Url" BusinessUrl	
--INTO #userChannel
from "Channel_Info" ci
join "Business" b on ci."Business_Id" = b."Business_Id"
left join "User_Channel" uc on ci."Channel_Info_Id" = uc."Channel_Info_Id"
left join "AspNetUserRoles" ur on uc."UserId" = ur."UserId"
left join "AspNetRoles" r on ur."RoleId" = r."Id"
left join "AspNetUsers" u on uc."UserId" = u."Id"
left join liveStream ls on ci."Channel_Info_Id" = ls.Channel_Info_Id and ls."rn" = 1
WHERE r."Name" in('Channel Owner','Admin') or r."Name" is null or r."Name" = ''
)
--select * from #userChannel

select u."Channel_Info_Id" "ChannelInfoId",
		u."Channel_Id" "ChannelId",		
		u."UserId",
		u."Business_Id" "BusinessId",		
		u."Channel_Desc" "ChannelDesc",
		u."Channel_Name" "ChannelName",
		u.ImageUrl "ImageUrl",
		u.ThumbnailImageUrl "ThumbnailImageUrl",
	    u."Business_Name" "BusinessName",
	    u."Business_Image" "BusinessImage",
		u."Background_Image" "BackgroundImage",
		u.Unique_Id "LiveUniqueId",
		u.EventName "EventName",
		u.EventDesc "EventDesc",
		u.EventImage "EventImage",
		u."Shortname",
		u.BusinessDescription "BusinessDescription",
		u.BusinessUrl "BusinessUrl"
from userChannel u
where rn = 1 
and (u."Channel_Id" = channelid1 or channelid1 is null)
and ("Channel_Info_Id" = channelinfoid1 or channelinfoid1 is null)
and ("Business_Id" = businessid1 or businessid1 is null)
group by  "Channel_Id",
		"Channel_Info_Id",
		"Business_Id",
		"UserId",
		"Name",
		"Channel_Name",
		"Channel_Desc",
		u.ImageUrl,
		u.ThumbnailImageUrl,
	    "Business_Name",
	    "Business_Image",
		"Background_Image",
		RoleNo,
		u.Unique_Id,
		u.EventName,
		u.EventDesc,
		u.EventImage,
		u."Shortname",
		u.BusinessDescription,
		u.BusinessUrl
order by "Channel_Id",RoleNo;

END; 
$BODY$;
