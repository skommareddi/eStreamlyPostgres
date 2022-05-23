
CREATE OR REPLACE FUNCTION getnewleads() 
 RETURNS TABLE (
 Business_User_Id	bigint
,UserName	varchar
,Company varchar
,Phone varchar
,Email varchar
,Role varchar
,Instagram_id varchar
,Youtube_Id varchar
,TikTok_Id varchar
,Facebook_Id varchar
,Twitter_Id varchar
,Created_Date timestamp with time zone
,Created_By varchar
,Modified_Date timestamp with time zone
,Modified_By varchar
,Record_Version numeric)
 LANGUAGE plpgsql  AS $$
	DECLARE 
     BEGIN
	
	RETURN QUERY
	SELECT * from "Business_User" order by "Created_Date" desc;
	
END
$$;