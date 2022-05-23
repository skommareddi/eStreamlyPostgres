 
 CREATE OR REPLACE FUNCTION GetPollResponsesByUniqueId (
UniqueId varchar
,ref1 refcursor)
RETURNS SETOF refcursor AS $$
BEGIN

OPEN ref1 FOR SELECT pr.*, pi.*
  FROM "Poll_Responses" pr
  inner join "Poll_Info" pi on pi."Poll_Info_Id" = pr."Poll_Info_Id"
  where pi."Unique_Id" = UniqueId;

RETURN NEXT ref1;
END
$$ LANGUAGE plpgsql;