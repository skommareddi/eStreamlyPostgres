CREATE OR REPLACE FUNCTION GetActiveParticipantsByUniqueId(uniqueId varchar,ref refcursor) 
RETURNS refcursor AS $$
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
$$ LANGUAGE plpgsql;
