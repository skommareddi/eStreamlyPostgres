
CREATE OR REPLACE FUNCTION public.getallvideodetailxml(
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN
	OPEN ref FOR select  ' <video:video>
<video:thumbnail_loc>' || "Media_thumbnail_Url" || '</video:thumbnail_loc>
      <video:title>' || 
	  REPLACE("Channel_Name", '&', 'And')  || '</video:title>
      <video:description>' ||
	  REPLACE("Channel_Desc" , '&', 'And')|| ' </video:description>
      <video:content_loc>'|| 
	  "Media_Url"  || '</video:content_loc>
      <video:player_loc>'
	   || 'https://estreamly.com/play?v='||m."Media_Unique_Id"  ||
	   '</video:player_loc>
   
     <video:view_count>'||  (ls."Viewer_Count" ::varchar ) || '</video:view_count>
	       <video:family_friendly>yes</video:family_friendly>
      <video:restriction relationship="allow">US</video:restriction>
    
      <video:requires_subscription>no</video:requires_subscription>
      <video:uploader
        info="http://www.estreamly.com">
        eStreamly
      </video:uploader>
      <video:live>no</video:live></video:video>' as xml
from "MediaByUserAndChannel" m 
join "Live_Stream_Info" ls on m."Media_Unique_Id" = ls."Unique_Id"

where   coalesce( m."Channel_Name", 'null') <> N'null' and coalesce(m."Media_thumbnail_Url", 'null') <> N'null'

union 
select  ' <video:video>
<video:thumbnail_loc>' || v."Video_Thumbnail_Url"|| '</video:thumbnail_loc>
      <video:title>' || 
	  REPLACE( v."Title", '&', 'And')|| '</video:title>
      <video:description>' ||
	  REPLACE(v."Description" , '&', 'And')|| ' </video:description>
      <video:content_loc>'|| 
	  "Video_Url"|| '</video:content_loc>
      <video:player_loc>'
	   || 'https://estreamly.com/play?v='||v."Video_Unique_Id"||
	   '</video:player_loc>
   
     <video:view_count>'|| (v."Viewer_Count" ::varchar) || '</video:view_count>
	       <video:family_friendly>yes</video:family_friendly>
      <video:restriction relationship="allow">US</video:restriction>
    
      <video:requires_subscription>no</video:requires_subscription>
      <video:uploader
        info="http://www.estreamly.com">
        eStreamly
      </video:uploader>
      <video:live>no</video:live></video:video>'  as xml
from "Video_Channel" v
where  coalesce(v."Title", 'null') <> N'null' and coalesce(v."M3U8_Video_Url", 'null') <> N'null';
	RETURN ref;
END;
$BODY$;
