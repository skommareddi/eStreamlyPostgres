CREATE PROCEDURE [dbo].[GetAllMedia]
(
    -- Add the parameters for the stored procedure here
@pageNumber int,
@pageSize int 
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
  select  0 IsLive
		,ci.Channel_Id ChannelId
		,ci.Channel_Name ChannelName
		,m.Media_Item_Id
		,m.User_Id [User_Id]
		,m.Media_Url Media_Url 
		,m.Media_thumbnail_Url Media_thumbnailUrl
		,m.Media_thumbnailGif_Url Media_thumbnailGifUrl
		,m.CreatedDate
		,ISNULL(u.ImageUrl,b.Business_Image) User_Profile_Image
		,ISNULL(u.ThumbnailImageUrl,b.Business_Image) User_Thumbnail_Image
		,m.Channel_Desc ChannelDesc
		,m.Media_Unique_Id Video_Id
		,0 IsUpcomingLiveStream
		,'media' MediaType	  
		,b.Business_Name BusinessName
		,b.Business_Image BusinessImage
		,b.Background_Image BackgroundImage
		,b.Shortname MerchantShortName
		,m.Desktop_Image_Url DesktopImageUrl
		,m.Mobile_Image_Url MobileImageUrl
		,m.Tablet_Image_Url TabletImageUrl
		,m.Channel_Desc EventDesc
		,m.Channel_Name EventName
		,Count(*) Over() AS TotalRows
		,m.Transcript_File_Url  TranscriptFileUrl
		,m.SRT_File_Url SRTFileUrl
		,m.VTT_File_Url VTTFileUrl
		,ls.Viewer_Count ViewerCount
		,ls.Like_Count TotalLikes
from MediaByUserAndChannel m
join Live_Stream_Info ls on m.Media_Unique_Id = ls.Unique_Id
join Channel_Info ci on ls.Channel_Info_Id = ci.Channel_Info_Id 
join Business b on ci.Business_Id = b.Business_Id
left join AspNetUsers u on m.User_Id = u.Id
left join Upcoming_Live_Stream ul on m.Media_Unique_Id = ul.Media_Unique_Id
where (ul.Is_Private_Event = 0 or ul.Is_Private_Event is null)
and (ul.Upcoming_Live_Stream_Id is null or (ul.Upcoming_Live_Stream_Id is not null and (ul.End_Date_Time is null or ul.End_Date_Time < GETDATE())))
and (ul.Is_Active  is null or ul.Is_Active = 'Y')
order by m.CreatedDate desc
OFFSET (@pageNumber - 1) * @pageSize ROWS
FETCH NEXT @pageSize ROWS ONLY
END