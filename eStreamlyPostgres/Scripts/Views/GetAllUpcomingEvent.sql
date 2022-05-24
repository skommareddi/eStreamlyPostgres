CREATE OR REPLACE VIEW GetAllUpcomingEvent
AS
select b."Background_Image" BusinessBackgroundImage
	  ,b."Business_Id" BusinessId
	  ,b."Business_Image" BusinessImage
	  ,b."Business_Name" BusinessName
	  ,b."Shortname" BusinessShortName
	  ,ci."Channel_Id" ChannelId
	  ,ci."Channel_Info_Id" ChannelInfoId
	  ,ul."Desktop_Image_Url" DesktopImageUrl
	  ,ul."Description" EventDesc
	  ,ul."End_Date_Time" EventEndTime
	  ,ul."Event_Image" EventImage
	  ,ul."Name" EventName
	  ,ul."Start_Date_Time" EventStartTime
	  ,CASE WHEN ul."Is_Private_Event"  = false THEN 'false' ELSE 'true' END IsPrivateEvent
	  ,ul."Mobile_Image_Url" MobileImageUrl
	  ,ul."Tablet_Image_Url" TabletImageUrl
	  ,ul."Media_Unique_Id" UniqueId
	  ,ul."Upcoming_Live_Stream_Id" UpcomingEventId
from "Upcoming_Live_Stream" ul
join "Channel_Info" ci on ul."Channel_Id" = ci."Channel_Id"
join "Business" b on ci."Business_Id" = b."Business_Id"
where ul."Start_Date_Time" > NOW()
and ul."Is_Private_Event"  = false;


