﻿
CREATE PROCEDURE [dbo].[GetAllVideoDetail] 
AS
select xml= ' <video:video>
<video:thumbnail_loc>"' + Media_thumbnail_Url + '"</video:thumbnail_loc>
      <video:title>' + 
	  Channel_Name  + '</video:title>
      <video:description>' +
	  REPLACE(Channel_Desc , '&', 'And')+ ' </video:description>
      <video:content_loc>"'+ 
	  Media_Url  + '"</video:content_loc>
      <video:player_loc>"'
	   + 'https://streamifyclient.azurewebsites.net/play?v='+m.Media_Unique_Id  +
	   '"</video:player_loc>
   
     <video:view_count>'+ CONVERT(nvarchar, ls.Viewer_Count ) + '</video:view_count>
	       <video:family_friendly>yes</video:family_friendly>
      <video:restriction relationship="allow">US</video:restriction>
    
      <video:requires_subscription>no</video:requires_subscription>
      <video:uploader
        info="http://www.estreamly.com">
        eStreamly
      </video:uploader>
      <video:live>no</video:live></video:video>'
from MediaByUserAndChannel m 
join Live_Stream_Info ls on m.Media_Unique_Id = ls.Unique_Id