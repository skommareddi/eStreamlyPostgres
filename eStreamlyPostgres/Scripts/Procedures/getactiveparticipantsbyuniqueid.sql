
CREATE OR REPLACE FUNCTION public.getactiveparticipantsbyuniqueid(
	uniqueid character varying,
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN
	OPEN ref FOR select pr."User_Id"
					   ,au."Email"
					   ,count(*) as ResponseCount
				from  "Poll_Info" pi 
				join "Poll_Responses" pr on pi."Poll_Info_Id" =  pr."Poll_Info_Id" 
				join "AspNetUsers" au on pr."User_Id" = au."Id"
				where pi."Unique_Id" = uniqueId
				group by pr."User_Id",au."Email"
				order by count(*) desc;
	RETURN ref;
END;
$BODY$;

