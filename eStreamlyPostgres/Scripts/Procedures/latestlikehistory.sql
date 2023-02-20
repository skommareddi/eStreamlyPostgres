
CREATE OR REPLACE FUNCTION public.latestlikehistory(
	)
    RETURNS TABLE(username character varying, email character varying, phonenumber character varying, fullname character varying, unique_id character varying, viewer_count bigint) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	DECLARE 
     BEGIN
	
	RETURN QUERY
	
SELECT u."UserName", u."Email", u."PhoneNumber", u."FullName", li."Unique_Id", li."Viewer_Count"
  FROM "Like_History" as l
  inner join "AspNetUsers" as u on l."User_Id" = u."Id"
  inner join "Live_Stream_Info" li on li."Live_Stream_Info_Id" = l."Live_Stream_Info_Id"
  order by l."Created_Date", li."Created_Date" desc;
END; 
$BODY$;

