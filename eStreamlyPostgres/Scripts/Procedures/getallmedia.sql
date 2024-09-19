CREATE OR REPLACE FUNCTION public.getallmedia(
	pagenumber integer,
	pagesize integer,
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

 BEGIN

DROP TABLE IF EXISTS list;
CREATE TEMP TABLE list AS
	select  0 IsLive
						,ci."Channel_Id" ChannelId
						,ci."Channel_Name" ChannelName
						,m."Media_Item_Id"
						,m."User_Id" 
						,m."Media_Url" Media_Url 
						,COALESCE(m."Uploaded_Event_Thumbnail_Image_Url",ul."Event_Image",m."Media_thumbnail_Url") Media_thumbnailUrl
						,m."Media_thumbnailGif_Url" Media_thumbnailGifUrl
						,m."CreatedDate"
						,DENSE_RANK() over(partition by b."Business_Id" order by  m."CreatedDate" desc) rn
						,DENSE_RANK() over( order by  m."CreatedDate" desc) rn1
						,coalesce(u."ImageUrl",b."Business_Image") User_Profile_Image
						,coalesce(u."ThumbnailImageUrl",b."Business_Image") User_Thumbnail_Image
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
						,m."Channel_Desc" EventDesc
						,m."Channel_Name" EventName
						,Count(*) Over() AS TotalRows
						,m."Transcript_File_Url"  TranscriptFileUrl
						,m."SRT_File_Url" SRTFileUrl
						,m."VTT_File_Url" VTTFileUrl
						,ls."Viewer_Count" ViewerCount
						,ls."Like_Count" TotalLikes
						
				from public."MediaByUserAndChannel" m
				join public."Live_Stream_Info" ls on m."Media_Unique_Id" = ls."Unique_Id"
				join public."Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
				join public."Business" b on ci."Business_Id" = b."Business_Id"
				left join public."AspNetUsers" u on m."User_Id" = u."Id"
				left join public."Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id"
				where (ul."Is_Private_Event" = false or ul."Is_Private_Event" is null)
				and (ul."Upcoming_Live_Stream_Id" is null or (ul."Upcoming_Live_Stream_Id" is not null and (ul."End_Date_Time" is null or ul."End_Date_Time" < NOW())))
				and (ul."Is_Active"  is null or ul."Is_Active" = 'Y')
				and m."Is_Active" = true
				and m."Is_Private_Event" = false;
						
DROP TABLE IF EXISTS list1;
CREATE TEMP TABLE list1 AS
select  *
from list
where rn = 1
limit 6 ;
				
-- OPEN ref FOR  

DROP TABLE IF EXISTS list2;
CREATE TEMP TABLE list2 AS
select l.*
from list l
left join list1 l1 on l.Video_Id = l1.Video_Id
where l1.Video_Id is not null
 order by l.rn asc , l."CreatedDate" desc;

insert into list2
select l.*
from list l
left join list1 l1 on l.Video_Id = l1.Video_Id
where l1.Video_Id is null
 order by  l."CreatedDate" desc;
--  Offset pageNumber * pageSize LIMIT pageSize;

	 OPEN ref FOR 
	select * from list2
	Offset pageNumber * pageSize LIMIT pageSize;
 RETURN ref;
  END
  
$BODY$;
