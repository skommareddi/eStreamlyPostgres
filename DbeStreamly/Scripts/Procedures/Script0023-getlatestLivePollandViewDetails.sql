
-- =============================================
-- Author:		smitha
-- Create date: Nov23
-- Description: for the latest live, get poll q, responses with user details, live view count and likes
-- =============================================
CREATE PROCEDURE [dbo].[getlatestLivePollandViewDetails]
	as
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT pr.Response_Info, pr.Created_Date, pi.Poll_Info_Detail, pi.Product_Id, li.Unique_Id,u.FullName, u.UserName, u.Email, u.PhoneNumber, li.Like_Count, li.Viewer_Count
  FROM [dbo].[Poll_Responses] pr
  inner join Poll_Info pi on pr.Poll_Info_Id = pr.Poll_Info_Id
  inner join AspNetUsers u on pr.User_Id = u.Id
  inner join Live_Stream_Info li on li.Unique_Id = pi.Unique_Id
 order by li.Created_Date desc
END