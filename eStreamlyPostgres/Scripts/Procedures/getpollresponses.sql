
CREATE OR REPLACE FUNCTION public.getpollresponses(
	uniqueid character varying)
    RETURNS TABLE(poll_type integer, poll_info_detail text, unique_id character varying, product_id bigint, user_id character varying, response_info character varying, email character varying, fullname character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

	DECLARE 
     BEGIN
	
	RETURN QUERY 
	select "Poll_Type", "Poll_Info_Detail", "Unique_Id", "Product_Id", "User_Id", "Response_Info", "Email", "FullName"
from "Poll_Info" p inner join "Poll_Responses" pr on p."Poll_Info_Id" = pr."Poll_Info_Id"
inner join "AspNetUsers" u on u."Id" = pr."User_Id"
where p."Unique_Id" = uniqueid;

END
$BODY$;

