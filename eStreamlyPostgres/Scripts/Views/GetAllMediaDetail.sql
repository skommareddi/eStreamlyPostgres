CREATE OR REPLACE VIEW GetAllMediaDetail
AS
select b."Background_Image" BusinessBackgroundImage
	  ,b."Business_Id" BusinessId
	  ,b."Business_Image" BusinessImage
	  ,b."Business_Name" BusinessName
	  ,b."Shortname" BusinessShortName
	  ,m."Channel_Desc" ChannelDesc
	  ,m."Channel_Id" ChannelId
	  ,m."Channel_Name" ChannelName
	  ,m."CreatedDate" CreatedDate
	  ,m."Desktop_Image_Url" DesktopImageUrl
	  ,m."Media_thumbnailGif_Url" MediaThumbnailGifUrl
	  ,m."Media_thumbnail_Url" MediaThumbnailUrl
	  ,m."Media_Unique_Id" MediaUniqueId
	  ,m."Media_Item_Id" Media_Id
	  ,m."Mobile_Image_Url" MobileImageUrl
	  ,m."Tablet_Image_Url" TabletImageUrl
	  ,m."Media_Unique_Id"  UniqueId
from "MediaByUserAndChannel" m
join "Live_Stream_Info" ls on m."Media_Unique_Id" = ls."Unique_Id"
join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
join "Business" b on ci."Business_Id" = b."Business_Id"
left join "Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id"
where (ul."Is_Private_Event" = false or ul."Is_Private_Event" is null)
and (ul."Upcoming_Live_Stream_Id" is null or (ul."Upcoming_Live_Stream_Id" is not null and (ul."End_Date_Time" is null or ul."End_Date_Time" < NOW())));



