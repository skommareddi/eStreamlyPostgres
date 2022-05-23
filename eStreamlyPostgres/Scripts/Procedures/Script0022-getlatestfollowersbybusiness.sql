
CREATE OR REPLACE FUNCTION  getlatestfollowersbybusiness() 
 RETURNS TABLE (
         Created_Date	timestamp
,FullName	varchar
,Email	varchar
,PhoneNumber	varchar
,Business_Name	varchar
,Business_Description	varchar)
 LANGUAGE plpgsql  AS $$
	DECLARE 
     BEGIN
	
	RETURN QUERY
	
 SELECT f."Created_Date", u."FullName", u."Email", u."PhoneNumber", b."Business_Name", b."Business_Description" 
  FROM "public"."Follower" f inner join "AspNetUsers" u on u."Id" = f."UserId" inner join "Business" b on b."Business_Id" = f."Business_Id"
  order by f."Created_Date" desc;

END
$$;
