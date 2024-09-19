CREATE OR REPLACE FUNCTION public.fn_get_timed_product_report(
	uniqueidparam text)
    RETURNS TABLE(postedtime text, productname character varying, handle character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	DECLARE 
     BEGIN
	
RETURN QUERY 
SELECT TO_CHAR(EXTRACT(EPOCH FROM (pi."Created_Date" - ls."Utc_Start_Time")) / 60, 'FM00') AS "PostedTime",
   p."Product_Name" "ProductName",
   p."Handle"
FROM "Live_Stream_Info" ls
JOIN "Poll_Info" pi ON ls."Unique_Id" = pi."Unique_Id"
join "Product" p on pi."Product_Id" = p."Product_Id"
where(ls."Unique_Id" = uniqueIdparam);

END;
$BODY$;
