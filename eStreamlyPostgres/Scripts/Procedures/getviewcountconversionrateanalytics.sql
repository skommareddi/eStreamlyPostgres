CREATE OR REPLACE FUNCTION public.getviewcountconversionrateanalytics(
	businessid bigint,
	fromdate timestamp without time zone,
	todate timestamp without time zone,
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
begin
OPEN ref FOR 
  select * 
  from(select ul."Description" "EventDescription"  
	  ,ul."Name" "EventName"
	  ,ul."Media_Unique_Id" "UpcomingUniqueId"
	  ,ul."Start_Date_Time" "EventStartTime"
	  ,ul."End_Date_Time" "EventEndTime"
	  ,ls."Like_Count" "LikeCount"
	  ,ls."Viewer_Count" "ViewerCount"
	  ,co."OrderCount"
	  ,up."UserCount"
	  ,coalesce(TRUNC((coalesce(co."OrderCount",0) :: decimal / coalesce(up."UserCount",1) :: decimal) * 100,2),0) "ConversionRate"
	   ,'Event' "Type"
	   ,coalesce(co."TotalRevenue",0) "TotalRevenue"
from "Upcoming_Live_Stream" ul
join "Live_Stream_Info" ls on ul."Media_Unique_Id" = ls."Unique_Id"
join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
left join (select count(distinct "UserId") "UserCount"
				 ,"UniqueId"
			from public."User_Participation_Details" 
			where "UserId" is not null
			group by "UniqueId") up on ul."Media_Unique_Id" = up."UniqueId"
left join (select count(distinct "UserId") "OrderCount",coalesce(TRUNC(sum("Amount" / 100),2),0) "TotalRevenue"
				 ,"Live_Unique_Id"
			from public."Customer_Order" 
-- 			where "UserId" is null or "UserId" != ''
			group by "Live_Unique_Id") co on ul."Media_Unique_Id" = co."Live_Unique_Id"
where ci."Business_Id" = businessId	
	   and (fromDate is not null and toDate is not null and (ul."Start_Date_Time" >= fromDate and ul."End_Date_Time" <= toDate))
	   and ul."Is_Active" = 'Y'
UNION 
	     select v."Description" "EventDescription"  
	  ,v."Title" "EventName"
	  ,v."Video_Unique_Id" "UpcomingUniqueId"
	  ,v."Created_Date" "EventStartTime"
	  ,v."Created_Date" "EventEndTime"
	  ,coalesce(v."Likes_Count",0) "LikeCount"
	  ,coalesce(v."Viewer_Count",0) "ViewerCount"
	  ,co."OrderCount"
	  ,up."UserCount"
	  ,coalesce(TRUNC((coalesce(co."OrderCount",0) :: decimal / coalesce(up."UserCount",1) :: decimal) * 100,2),0) "ConversionRate"
	    ,'Video' "Type"
	  ,coalesce(co."TotalRevenue",0) "TotalRevenue"
from "Video_Channel" v
join "Channel_Info" ci on v."Channel_Id" = ci."Channel_Id"
left join (select count(distinct "UserId") "UserCount"
				 ,"UniqueId"
			from public."User_Participation_Details" 
			where "UserId" is not null
			group by "UniqueId") up on v."Video_Unique_Id" = up."UniqueId"
left join (select count(distinct "UserId") "OrderCount",TRUNC(sum("Amount" / 100),2) "TotalRevenue"
				 ,"Live_Unique_Id"
			from public."Customer_Order" 
-- 			where "UserId" is null or "UserId" != ''
			group by "Live_Unique_Id") co on v."Video_Unique_Id" = co."Live_Unique_Id"
where  v."Is_Active" = true
and ci."Business_Id" = businessId
and (fromDate is not null and toDate is not null and v."Created_Date" >= fromDate and v."Created_Date" <= toDate)) s
order by s."EventStartTime";
 RETURN ref;
end;
$BODY$;
