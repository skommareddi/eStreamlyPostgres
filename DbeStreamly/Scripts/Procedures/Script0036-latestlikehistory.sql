
-- =============================================
-- Author:		smitha
-- Create date: Nov23
-- Description:	most recent like on top
-- =============================================
CREATE PROCEDURE [dbo].[latestlikehistory]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT u.UserName, u.Email, u.PhoneNumber, u.FullName, li.Unique_Id, li.Viewer_Count
  FROM [dbo].[Like_History] as l
  inner join AspNetUsers as u on l.User_Id = u.Id
  inner join Live_Stream_Info li on li.Live_Stream_Info_Id = l.Live_Stream_Info_Id
  order by l.Created_Date, li.Created_Date desc
END