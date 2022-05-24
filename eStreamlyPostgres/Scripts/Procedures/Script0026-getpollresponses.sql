CREATE PROCEDURE [dbo].[getpollresponses]
-- Add the parameters for the stored procedure here
	@uniqueid varchar(250) 	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
select Poll_Type, Poll_Info_Detail, Unique_Id, Product_Id, User_Id, Response_Info, Email, FullName
from Poll_Info p inner join Poll_Responses pr on p.Poll_Info_Id = pr.Poll_Info_Id
inner join AspNetUsers u on u.Id = pr.User_Id
where p.Unique_Id = @uniqueid
END