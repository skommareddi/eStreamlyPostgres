
CREATE OR REPLACE FUNCTION public.generatevideositemap(
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN

	OPEN ref FOR
select ' <url> 
<loc>https://streamifyclient.azurewebsites.net/' || COALESCE(b."Shortname",'') || '/' || COALESCE(m."Modified_Title",'') || ' </loc>
<video:video>
<video:thumbnail_loc>"' || "Media_thumbnail_Url" || '"</video:thumbnail_loc>
      <video:title>' || 
	  COALESCE(m."Channel_Name",'')  || '</video:title>
      <video:description>' ||
	  REPLACE(COALESCE(m."Channel_Desc",'') , '&', 'And')|| ' </video:description>
      <video:content_loc>"'|| 
	  "Media_Url"  || '"</video:content_loc>
      <video:player_loc>"'
	   || 'https://streamifyclient.azurewebsites.net/play?v='|| m."Media_Unique_Id"  ||
	   '"</video:player_loc>
   
     <video:view_count>'||  COALESCE(ls."Viewer_Count",0) :: varchar || '</video:view_count>
	       <video:family_friendly>yes</video:family_friendly>
      <video:restriction relationship="allow">US</video:restriction>
    
      <video:requires_subscription>no</video:requires_subscription>
      <video:uploader
        info="http://www.estreamly.com">
        eStreamly
      </video:uploader>
      <video:live>no</video:live></video:video>
	  </url>' as xml
from "MediaByUserAndChannel" m 
join "Live_Stream_Info" ls on m."Media_Unique_Id" = ls."Unique_Id"
join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
join "Business" b on ci."Business_Id" = b."Business_Id"
left join public."Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id"
				where (ul."Is_Private_Event" = false or ul."Is_Private_Event" is null)
				and (ul."Upcoming_Live_Stream_Id" is null or (ul."Upcoming_Live_Stream_Id" is not null and (ul."End_Date_Time" is null or ul."End_Date_Time" < NOW())))
				and (ul."Is_Active"  is null or ul."Is_Active" = 'Y')
UNION
select ' <url> 
<loc>https://streamifyclient.azurewebsites.net/' || COALESCE(b."Shortname",'') || '/' || COALESCE(m."Modified_Title",'') || ' </loc>
<video:video>
<video:thumbnail_loc>"' || m."Video_Thumbnail_Url" || '"</video:thumbnail_loc>
      <video:title>' || 
	  COALESCE(m."Title",'')  || '</video:title>
      <video:description>' ||
	  REPLACE(COALESCE(m."Description",'') , '&', 'And')|| ' </video:description>
      <video:content_loc>"'|| 
	  "M3U8_Video_Url"  || '"</video:content_loc>
      <video:player_loc>"'
	   || 'https://streamifyclient.azurewebsites.net/play?v='|| m."Video_Unique_Id"  ||
	   '"</video:player_loc>
   
     <video:view_count>'||  COALESCE(m."Viewer_Count",0) :: varchar || '</video:view_count>
	       <video:family_friendly>yes</video:family_friendly>
      <video:restriction relationship="allow">US</video:restriction>
    
      <video:requires_subscription>no</video:requires_subscription>
      <video:uploader
        info="http://www.estreamly.com">
        eStreamly
      </video:uploader>
      <video:live>no</video:live></video:video>
	  </url>' as xml
from "Video_Channel" m
join "Channel_Info" ci on m."Channel_Id" = ci."Channel_Id" 
join "Business" b on ci."Business_Id" = b."Business_Id"
join "AspNetUsers" u on m."User_Id" = u."Id"
where b."Is_Active" = 'Y' and m."M3U8_Video_Url" is not null and m."Is_Active" = true;

RETURN ref;
END;
$BODY$;
