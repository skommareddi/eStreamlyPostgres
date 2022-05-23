CREATE OR REPLACE FUNCTION latestlikehistory() 
    RETURNS TABLE (
         UserName	varchar
,Email	varchar
,PhoneNumber	varchar
,FullName	varchar
,Unique_Id	varchar
,Viewer_Count	bigint)
    LANGUAGE plpgsql  AS $$
	DECLARE 
     BEGIN
	
	RETURN QUERY
	
SELECT u."UserName", u."Email", u."PhoneNumber", u."FullName", li."Unique_Id", li."Viewer_Count"
  FROM "Like_History" as l
  inner join "AspNetUsers" as u on l."User_Id" = u."Id"
  inner join "Live_Stream_Info" li on li."Live_Stream_Info_Id" = l."Live_Stream_Info_Id"
  order by l."Created_Date", li."Created_Date" desc;
END; 
$$;