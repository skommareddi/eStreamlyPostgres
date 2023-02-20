
CREATE OR REPLACE FUNCTION public.getfollowerlistbystreamid(
	streamid character varying,
	uniqueidparam character varying)
    RETURNS TABLE(channelid character varying, businessid bigint, uniqueid character varying, eventname character varying, eventdescription character varying, eventimage character varying, businessimage character varying, businessname character varying, userid character varying, fullname character varying, email character varying) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

	DECLARE 
     BEGIN
	
	RETURN QUERY 
   CREATE TEMP TABLE channelDetail AS 
    select ci."Channel_Id" ChannelId
		  ,b."Business_Id" BusinessId
		  ,ul."Media_Unique_Id" UniqueId
		  ,ul."Name" EventName
		  ,ul."Description" EventDescription
		  ,ul."Event_Image" EventImage
		  ,b."Business_Image" BusinessImage
		  ,b."Business_Name"  BusinessName
	from "Live_Stream_Info" ls 
	join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
	join "Business" b on ci."Business_Id" = b."Business_Id"
	join "Upcoming_Live_Stream" ul on ISNULL(ls."Upcoming_Unique_Id",ls."Unique_Id" ) = ul."Media_Unique_Id"
	where (streamId is null or streamId = 'null' or ls."Stream_Id" = streamId)
	and (uniqueIdparam is null or ul."Media_Unique_Id" = uniqueIdparam);
	
	select distinct c.*
		  ,f."UserId"
		  ,au."FullName"
		  ,au."Email"
	from channelDetail c
	join "Follower" f on c."BusinessId" = f."Business_Id"
	join "AspNetUsers" au on f."UserId" = au."Id";

	drop table channelDetail;
END;
$BODY$;

