
CREATE OR REPLACE FUNCTION public.getallorders(
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN
	OPEN ref FOR select * 
				 from public."Customer_Order" co
				 join public."AspNetUsers" u on u."Id" = co."UserId"
				 join public."Product" p on p."Product_Id"= co."Product_Id"
				 order by  co."Created_Date" desc;
	RETURN ref;
END;
$BODY$;
