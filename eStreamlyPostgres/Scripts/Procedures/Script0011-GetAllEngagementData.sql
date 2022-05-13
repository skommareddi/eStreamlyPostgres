
-- =============================================
-- Author:	Smitha
-- Create date: 3/23/2022
-- Description:	Get all Engagement data. This is sproc is for business folks to lookup data
-- this is not for developers
-- =============================================
CREATE PROCEDURE [dbo].[GetAllEngagementData]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   SELECT u.[FullName], u.Email, u.PhoneNumber, up.UniqueId , up.Type,  up.Product_Id, up.Payment_Method,up.Participated_Count, up.Created_Date
     
  FROM [dbo].[User_Participation_Details] up inner join [dbo].[AspNetUsers] u
  on u.Id = up.UserId
  order by up.Created_Date desc
END