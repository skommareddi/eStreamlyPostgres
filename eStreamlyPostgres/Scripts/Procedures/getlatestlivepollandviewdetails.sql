
CREATE OR REPLACE FUNCTION public.getlatestlivepollandviewdetails(
	)
    RETURNS TABLE(response_info character varying, created_date timestamp without time zone, poll_info_detail text, product_id bigint, unique_id character varying, fullname character varying, username character varying, email character varying, phonenumber character varying, like_count bigint, viewer_count bigint) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

	DECLARE 
     BEGIN
	
	RETURN QUERY
	SELECT pr."Response_Info", pr."Created_Date", pi."Poll_Info_Detail", pi."Product_Id", 
	li."Unique_Id",u."FullName", u."UserName", u."Email", u."PhoneNumber", li."Like_Count", li."Viewer_Count"
  FROM "public"."Poll_Responses" pr
  inner join "Poll_Info" pi on pr."Poll_Info_Id" = pr."Poll_Info_Id"
  inner join "AspNetUsers" u on pr."User_Id" = u."Id"
  inner join "Live_Stream_Info" li on li."Unique_Id" = pi."Unique_Id"
 order by li."Created_Date" desc;

END
$BODY$;

