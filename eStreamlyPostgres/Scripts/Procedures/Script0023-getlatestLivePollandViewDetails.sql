
CREATE OR REPLACE FUNCTION getlatestLivePollandViewDetails() 
 RETURNS TABLE (
	 Response_Info	varchar
	 ,Created_Date timestamp
	 ,Poll_Info_Detail	text
	 ,Product_Id	bigint
	 ,Unique_Id varchar
	 ,FullName varchar
	 ,UserName	varchar
	 ,Email	varchar
	 ,PhoneNumber	varchar
	 ,Like_Count bigint
	 ,Viewer_Count bigint )
 LANGUAGE plpgsql  AS $$
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
$$;