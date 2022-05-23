CREATE OR REPLACE FUNCTION GetFollowerListByStreamId (streamId varchar ,uniqueIdparam varchar)
RETURNS TABLE (
 ChannelId	varchar
,BusinessId bigint
,UniqueId varchar
,EventName varchar
,EventDescription varchar
,EventImage varchar
,BusinessImage varchar
,BusinessName varchar
,UserId varchar
,FullName varchar
,Email varchar)
 LANGUAGE plpgsql  AS $$
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
$$;