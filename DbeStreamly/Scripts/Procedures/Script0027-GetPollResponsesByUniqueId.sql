CREATE PROCEDURE [dbo].[GetPollResponsesByUniqueId] (@UniqueId varchar(250) = '')
AS
BEGIN

SELECT pr.*, pi.*
  FROM [dbo].[Poll_Responses] pr
  inner join Poll_Info pi on pi.Poll_Info_Id= pr.Poll_Info_Id
  where pi.Unique_Id = @UniqueId 

  END