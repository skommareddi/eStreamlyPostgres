
CREATE OR REPLACE FUNCTION public.getrecordedeventbymerchant(
	shortname character varying,
	pagenumber integer,
	pagesize integer,
	refcursor1 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

BEGIN

OPEN refcursor1 FOR
select * from 
(select  0 IsLive
	    ,ci."Channel_Id" ChannelId
	    ,ci."Channel_Name" ChannelName
	    ,m."Media_Item_Id"
	    ,m."User_Id" 
	    ,m."Media_Url" Media_Url 
	    ,COALESCE(m."Uploaded_Event_Thumbnail_Image_Url",m."Media_thumbnail_Url")  Media_thumbnailUrl
	    ,m."Media_thumbnailGif_Url" Media_thumbnailGifUrl
	    ,m."CreatedDate"
	    ,u."ImageUrl" User_Profile_Image
	    ,u."ThumbnailImageUrl" User_Thumbnail_Image
	    ,m."Channel_Desc" ChannelDesc
	    ,m."Media_Unique_Id" Video_Id
	    ,0 IsUpcomingLiveStream
	    ,'media' MediaType	  
	    ,b."Business_Name" BusinessName
	    ,b."Business_Image" BusinessImage
	    ,b."Background_Image" BackgroundImage
	    ,b."Shortname" MerchantShortName
	    ,m."Desktop_Image_Url" DesktopImageUrl
	    ,m."Mobile_Image_Url" MobileImageUrl
	    ,m."Tablet_Image_Url" TabletImageUrl	
		,m."Channel_Name" EventName
		,m."Channel_Desc" EventDesc
 		,m."Modified_Title" "ModifiedTitle"
 ,ul."Keywords" "Keyword"
from "MediaByUserAndChannel" m
join "Live_Stream_Info" ls on m."Media_Unique_Id" = ls."Unique_Id"
join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id" 
join "Business" b on ci."Business_Id" = b."Business_Id"
join "AspNetUsers" u on m."User_Id" = u."Id"
 left join "Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id" 
where Lower(b."Shortname") = Lower(shortname)
and b."Is_Active" = 'Y' and (ul."Is_Private_Event" is null or ul."Is_Private_Event" = false) 
 and m."Is_Active" = true
 and m."Is_Private_Event" = false
UNION
select  0 IsLive
	    ,ci."Channel_Id" ChannelId
	    ,ci."Channel_Name" ChannelName
	    ,m."Video_Channel_Id" Media_Item_Id
	    ,m."User_Id"
	    ,m."M3U8_Video_Url" Media_Url 
	    ,m."Video_Thumbnail_Url"  Media_thumbnailUrl
	    ,m."Video_Gif_Url" Media_thumbnailGifUrl
	    ,m."Created_Date" CreatedDate
	    ,u."ImageUrl" User_Profile_Image
	    ,u."ThumbnailImageUrl" User_Thumbnail_Image
	    ,m."Description" ChannelDesc
	    ,m."Video_Unique_Id" Video_Id
	    ,0 IsUpcomingLiveStream
	    ,'media' MediaType	  
	    ,b."Business_Name" BusinessName
	    ,b."Business_Image" BusinessImage
	    ,b."Background_Image" BackgroundImage
	    ,b."Shortname" MerchantShortName
	    ,m."Desktop_Thumbnail_Url" DesktopImageUrl
	    ,m."Mobile_Thumbnail_Url" MobileImageUrl
	    ,m."Tablet_Thumbnail_Url" TabletImageUrl	
		,m."Title" EventName
		,m."Description" EventDesc
		,m."Modified_Title" "ModifiedTitle"
  ,m."Keywords" "Keyword"
from "Video_Channel" m
join "Channel_Info" ci on m."Channel_Id" = ci."Channel_Id" 
join "Business" b on ci."Business_Id" = b."Business_Id"
join "AspNetUsers" u on m."User_Id" = u."Id"
where b."Is_Active" = 'Y' and m."M3U8_Video_Url" is not null and m."Is_Active" = true
and  Lower(b."Shortname") = Lower(shortname)) d
order by "CreatedDate" desc
LIMIT pageSize
   OFFSET ((pageNumber-1) * pageSize);
RETURN NEXT refcursor1;		

END;
$BODY$;
