CREATE PROCEDURE [dbo].[GetFollowerListByStreamId]
(
    -- Add the parameters for the stored procedure here
@streamId varchar(250),
@uniqueId varchar(250)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
   select ci.Channel_Id ChannelId
		  ,b.Business_Id BusinessId
		  ,ul.Media_Unique_Id UniqueId
		  ,ul.Name EventName
		  ,ul.Description EventDescription
		  ,ul.Event_Image EventImage
		  ,b.Business_Image BusinessImage
		  ,b.Business_Name  BusinessName
	INTO #channelDetail
	from Live_Stream_Info ls 
	join Channel_Info ci on ls.Channel_Info_Id = ci.Channel_Info_Id
	join Business b on ci.Business_Id = b.Business_Id
	join Upcoming_Live_Stream ul on ISNULL(ls.Upcoming_Unique_Id,ls.Unique_Id ) = ul.Media_Unique_Id
	where (@streamId is null or @streamId = 'null' or ls.Stream_Id = @streamId)
	and (@uniqueId is null or ul.Media_Unique_Id = @uniqueId)
	
	select distinct c.*
		  ,f.UserId
		  ,au.FullName
		  ,au.Email
	from #channelDetail c
	join Follower f on c.BusinessId = f.Business_Id
	join AspNetUsers au on f.UserId = au.Id
	--where au.Id = '782871de-d54c-4115-8dc1-621cc138d48a'
	--where au.Id = '101890539619730388902'

	drop table #channelDetail

END