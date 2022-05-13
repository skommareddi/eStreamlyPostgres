CREATE PROCEDURE [dbo].[GetAllVideoDetailxml] 
AS
select xml= ' <video:video>
<video:thumbnail_loc>' + Media_thumbnail_Url + '</video:thumbnail_loc>
      <video:title>' + 
	  REPLACE(Channel_Name, '&', 'And')  + '</video:title>
      <video:description>' +
	  REPLACE(Channel_Desc , '&', 'And')+ ' </video:description>
      <video:content_loc>'+ 
	  Media_Url  + '</video:content_loc>
      <video:player_loc>'
	   + 'https://estreamly.com/play?v='+m.Media_Unique_Id  +
	   '</video:player_loc>
   
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

where   isnull( m.Channel_Name, 'null') <> N'null' and isnull(m.Media_thumbnail_Url, 'null') <> N'null'

union 
select  xml= ' <video:video>
<video:thumbnail_loc>' + v.[Video_Thumbnail_Url]+ '</video:thumbnail_loc>
      <video:title>' + 
	  REPLACE( v.[Title], '&', 'And')+ '</video:title>
      <video:description>' +
	  REPLACE(v.[Description] , '&', 'And')+ ' </video:description>
      <video:content_loc>'+ 
	  [Video_Url]+ '</video:content_loc>
      <video:player_loc>'
	   + 'https://estreamly.com/play?v='+v.[Video_Unique_Id]+
	   '</video:player_loc>
   
     <video:view_count>'+ CONVERT(nvarchar, v.[Viewer_Count]) + '</video:view_count>
	       <video:family_friendly>yes</video:family_friendly>
      <video:restriction relationship="allow">US</video:restriction>
    
      <video:requires_subscription>no</video:requires_subscription>
      <video:uploader
        info="http://www.estreamly.com">
        eStreamly
      </video:uploader>
      <video:live>no</video:live></video:video>'
from Video_Channel v
where  isnull(v.Title, 'null') <> N'null' and isnull(v.M3U8_Video_Url, 'null') <> N'null'