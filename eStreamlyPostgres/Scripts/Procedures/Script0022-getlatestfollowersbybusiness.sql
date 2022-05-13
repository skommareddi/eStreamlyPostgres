CREATE PROCEDURE [dbo].[getlatestfollowersbybusiness]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT f.Created_Date, u.FullName, u.Email, u.PhoneNumber, b.Business_Name, b.Business_Description 
  FROM [dbo].[Follower] f inner join AspNetUsers u on u.Id = f.UserId inner join Business b on b.Business_Id = f.Business_Id
  order by f.[Created_Date] desc
END