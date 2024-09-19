CREATE OR REPLACE FUNCTION public.fn_get_on_live_post_live_data(
	uniqueid character varying,
	ref1 refcursor,
	ref2 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

BEGIN
	OPEN ref1 FOR
	SELECT distinct	upd."UserId",
	upd."Guest_User_Id" "GuestUserId",
	COALESCE(upd."UserId", upd."Guest_User_Id") AS "Viewer",
    upd."Created_Date" AS "EngagementCreatedDate",
    upd."Type" AS "ViewerActivity",
	upd."Keyword",
    upd."UniqueId" AS "UniqueId",
	COALESCE(ls."Viewer_Count",vc."Viewer_Count") "Viewer_Count",
	COALESCE(ls."Concurrent_Viewer_Count",vc."Viewer_Count") "Concurrent_Viewer_Count",
	COALESCE(uls."Name",vc."Title",'Instant Live') "EventName",
	COALESCE(uls."Event_Image",mbuc."Media_thumbnail_Url",vc."Video_Thumbnail_Url",b."Background_Image") "EventImage",
    COALESCE(ls."Start_Time",uls."Start_Date_Time",vc."Created_Date") AS "EventStartTime",
    COALESCE( uls."End_Date_Time",ls."End_Time",(COALESCE (ls."Start_Time",uls."Start_Date_Time") + ( mbuc."DurationInSeconds" || ' Seconds') :: interval),(vc."Created_Date" + ( vc."Duration" || ' Seconds') :: interval)) AS "EventEndTime",
	round(co."Amount" / 100, 2) "Amount",
	co."TotalOrderCount",
	co."TotalUniqueOrderCount",
	COALESCE(ls."Channel_Info_Id",vc."Channel_Info_Id") "Channel_Info_Id",
	ls."Total_Watched_Minutes" "TotalMinutesWatched"
     FROM "User_Participation_Details" upd
     LEFT JOIN "MediaByUserAndChannel" mbuc ON upd."UniqueId" = mbuc."Media_Unique_Id"
	 LEFT JOIN "Live_Stream_Info" ls ON upd."UniqueId" = ls."Unique_Id"
     LEFT JOIN "Upcoming_Live_Stream" uls ON mbuc."Media_Unique_Id" = uls."Media_Unique_Id"
     LEFT JOIN "Channel_Info" ci ON ls."Channel_Info_Id" = ci."Channel_Info_Id"
     LEFT JOIN "Business" b ON ci."Business_Id" = b."Business_Id"
	 LEFT JOIN "Video_Channel" vc ON upd."UniqueId" = vc."Video_Unique_Id"
	 LEFT JOIN (select "Live_Unique_Id",SUM("Amount") "Amount" ,
			 	COUNT(DISTINCT COALESCE("UserId","Guest_User_Id")) "TotalUniqueOrderCount",
				COUNT("Customer_Order_Id") "TotalOrderCount"
				from "Customer_Order" co
				LEFT JOIN "MediaByUserAndChannel" mbuc ON co."Live_Unique_Id" = mbuc."Media_Unique_Id"
				LEFT JOIN "Live_Stream_Info" ls ON co."Live_Unique_Id" = ls."Unique_Id"
				LEFT JOIN "Upcoming_Live_Stream" uls ON mbuc."Media_Unique_Id" = uls."Media_Unique_Id"
				LEFT JOIN "Video_Channel" vc ON co."Live_Unique_Id"  = vc."Video_Unique_Id"
				where "Live_Unique_Id" = uniqueId
				and co."Is_Payment_Confirmed" = 'Y'
				and  co."Created_Date" >=  COALESCE (ls."Start_Time",uls."Start_Date_Time",vc."Created_Date")
  AND  co."Created_Date" <=  COALESCE( ls."End_Time",(COALESCE (ls."Start_Time",uls."Start_Date_Time") + (mbuc."DurationInSeconds" || ' Seconds') :: interval),uls."End_Date_Time",(vc."Created_Date" + ( vc."Duration" || ' Seconds') :: interval))
				group by "Live_Unique_Id") co on ls."Unique_Id" = co."Live_Unique_Id"
  WHERE  upd."Created_Date" >=  COALESCE (ls."Start_Time",uls."Start_Date_Time")
  AND  upd."Created_Date" <=  COALESCE( ls."End_Time",(COALESCE (ls."Start_Time",uls."Start_Date_Time") + (mbuc."DurationInSeconds" || ' Seconds') :: interval),uls."End_Date_Time",(vc."Created_Date" + ( vc."Duration" || ' Seconds') :: interval))
  AND upd."UniqueId" = uniqueId;
RETURN NEXT ref1;

OPEN ref2 FOR
SELECT distinct	upd."UserId",
	upd."Guest_User_Id" "GuestUserId",
	COALESCE(upd."UserId", upd."Guest_User_Id") AS "Viewer",
    upd."Created_Date" AS "EngagementCreatedDate",
    upd."Type" AS "ViewerActivity",
	upd."Keyword",
    upd."UniqueId" AS "UniqueId",
	COALESCE(ls."Viewer_Count",vc."Viewer_Count") "Viewer_Count",
	COALESCE(ls."Concurrent_Viewer_Count",vc."Viewer_Count") "Concurrent_Viewer_Count",
	COALESCE(uls."Name",vc."Title",'Instant Live') "EventName",
	COALESCE(uls."Event_Image",mbuc."Media_thumbnail_Url",vc."Video_Thumbnail_Url",b."Background_Image") "EventImage",
    COALESCE(ls."Start_Time",uls."Start_Date_Time",vc."Created_Date") AS "EventStartTime",
    COALESCE( uls."End_Date_Time",ls."End_Time",(COALESCE (ls."Start_Time",uls."Start_Date_Time") + ( mbuc."DurationInSeconds" || ' Seconds') :: interval),(vc."Created_Date" + ( vc."Duration" || ' Seconds') :: interval)) AS "EventEndTime",
	round(co."Amount" / 100, 2) "Amount",
	co."TotalOrderCount",
	co."TotalUniqueOrderCount",
	COALESCE(ls."Channel_Info_Id",vc."Channel_Info_Id") "Channel_Info_Id",
	ls."Total_Watched_Minutes" "TotalMinutesWatched"
     FROM "User_Participation_Details" upd
     LEFT JOIN "MediaByUserAndChannel" mbuc ON upd."UniqueId" = mbuc."Media_Unique_Id"
	 LEFT JOIN "Live_Stream_Info" ls ON upd."UniqueId" = ls."Unique_Id"
     LEFT JOIN "Upcoming_Live_Stream" uls ON mbuc."Media_Unique_Id" = uls."Media_Unique_Id"
     LEFT JOIN "Channel_Info" ci ON ls."Channel_Info_Id" = ci."Channel_Info_Id"
     LEFT JOIN "Business" b ON ci."Business_Id" = b."Business_Id"
	 LEFT JOIN "Video_Channel" vc ON upd."UniqueId" = vc."Video_Unique_Id"
	 LEFT JOIN (select "Live_Unique_Id",SUM("Amount") "Amount" ,
				COUNT(DISTINCT COALESCE("UserId","Guest_User_Id")) "TotalUniqueOrderCount",
				COUNT("Customer_Order_Id") "TotalOrderCount"
				from "Customer_Order" co
				LEFT JOIN "MediaByUserAndChannel" mbuc ON co."Live_Unique_Id" = mbuc."Media_Unique_Id"
				LEFT JOIN "Live_Stream_Info" ls ON co."Live_Unique_Id" = ls."Unique_Id"
				LEFT JOIN "Upcoming_Live_Stream" uls ON mbuc."Media_Unique_Id" = uls."Media_Unique_Id"
				 LEFT JOIN "Video_Channel" vc ON co."Live_Unique_Id" = vc."Video_Unique_Id"
				where "Live_Unique_Id" = uniqueId
				and co."Is_Payment_Confirmed" = 'Y'
					and co."Created_Date" > COALESCE( ls."End_Time",(COALESCE (ls."Start_Time",uls."Start_Date_Time") + ( COALESCE(mbuc."DurationInSeconds",0) || ' Seconds') :: interval),uls."End_Date_Time",(vc."Created_Date" + ( vc."Duration" || ' Seconds') :: interval))
				group by "Live_Unique_Id") co on COALESCE(ls."Unique_Id",vc."Video_Unique_Id") = co."Live_Unique_Id"
  WHERE upd."Created_Date" > COALESCE( ls."End_Time",(COALESCE (ls."Start_Time",uls."Start_Date_Time") + ( mbuc."DurationInSeconds" || ' Seconds') :: interval),uls."End_Date_Time",(vc."Created_Date" + ( COALESCE(vc."Duration",0) || ' Seconds') :: interval))
  AND upd."UniqueId" = uniqueId;
RETURN NEXT ref2;
END;
$BODY$;