CREATE OR REPLACE FUNCTION getpollresponses(uniqueid varchar) 
RETURNS TABLE (
 Poll_Type	integer
,Poll_Info_Detail text
,Unique_Id varchar
,Product_Id bigint
,User_Id varchar
,Response_Info varchar
,Email varchar
,FullName varchar)
 LANGUAGE plpgsql  AS $$
	DECLARE 
     BEGIN
	
	RETURN QUERY 
	select "Poll_Type", "Poll_Info_Detail", "Unique_Id", "Product_Id", "User_Id", "Response_Info", "Email", "FullName"
from "Poll_Info" p inner join "Poll_Responses" pr on p."Poll_Info_Id" = pr."Poll_Info_Id"
inner join "AspNetUsers" u on u."Id" = pr."User_Id"
where p."Unique_Id" = uniqueid;

END
$$;