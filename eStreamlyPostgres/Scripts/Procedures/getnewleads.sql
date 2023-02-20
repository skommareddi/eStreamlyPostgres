
CREATE OR REPLACE FUNCTION public.getnewleads(
	)
    RETURNS TABLE(business_user_id bigint, username character varying, company character varying, phone character varying, email character varying, role character varying, instagram_id character varying, youtube_id character varying, tiktok_id character varying, facebook_id character varying, twitter_id character varying, created_date timestamp with time zone, created_by character varying, modified_date timestamp with time zone, modified_by character varying, record_version numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

	DECLARE 
     BEGIN
	
	RETURN QUERY
	SELECT * from "Business_User" order by "Created_Date" desc;
	
END
$BODY$;

