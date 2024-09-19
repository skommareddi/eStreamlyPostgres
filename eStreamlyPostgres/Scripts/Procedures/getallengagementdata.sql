CREATE OR REPLACE FUNCTION public.getallengagementdata(
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
BEGIN
	OPEN ref FOR SELECT u."FullName"
				   ,u."Email"
				   ,u."PhoneNumber"
				   ,up."UniqueId"
				   ,up."Type"
				   ,up."Product_Id"
				   ,up."Payment_Method"
				   ,up."Participated_Count"
				   ,up."Created_Date"     
			  FROM public."User_Participation_Details" as  up
			  join public."AspNetUsers" as  u on u."Id" = up."UserId"
			  order by up."Created_Date" desc;
	RETURN ref;
END;
$BODY$;
