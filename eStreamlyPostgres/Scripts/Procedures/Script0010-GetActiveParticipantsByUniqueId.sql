CREATE PROCEDURE [dbo].[GetActiveParticipantsByUniqueId](@uniqueId varchar(250) )
AS 
BEGIN
--declare @uniqueId varchar(250) = 'nR3fapFXGN4'
select pr.User_Id,au.Email,count(*) as ResponseCount
from  Poll_Info pi 
join poll_Responses pr on pi.poll_info_id =  pr.poll_info_id 
join AspNetUsers au on pr.user_id = au.Id
where pi.Unique_Id = @uniqueId
group by pr.User_Id,au.Email
order by count(*) desc--,pi.Poll_Info_Id
END