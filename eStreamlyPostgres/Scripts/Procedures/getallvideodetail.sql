CREATE OR REPLACE FUNCTION public.getallvideodetail(
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN
	OPEN ref FOR
select ' <url> 
<loc>https://estreamly.com/' || b."Shortname" || '/' || m."Modified_Title" || ' </loc>
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
join "Business" b on ci."Business_Id" = b."Business_Id";

RETURN ref;
END;
$BODY$;
