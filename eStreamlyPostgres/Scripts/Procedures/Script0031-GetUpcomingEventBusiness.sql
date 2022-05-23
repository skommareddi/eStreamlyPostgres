CREATE OR REPLACE FUNCTION GetUpcomingEventBusiness()
RETURNS TABLE (
	BusinessName VARCHAR,
	BusinessImage VARCHAR,
	Shortname VARCHAR,
	BackgroundImage VARCHAR,
	FollowersCount numeric,
	BusinessId bigint
)
LANGUAGE plpgsql  AS $$
	DECLARE 
    BEGIN	
	CREATE TEMP TABLE upcomingEvents
	(
	BusinessId bigint ,
	CreatedDate timestamp null
	);
	INSERT INTO upcomingEvents
	select ci."Business_Id" BusinessId
	,m."CreatedDate" CreatedDate
	from "Upcoming_Live_Stream" ul
	join "Channel_Info" ci on ul."Channel_Id" = ci."Channel_Id"
	join "MediaByUserAndChannel" m on ul."Media_Unique_Id" = m."Media_Unique_Id"
	where ul."Is_Private_Event" = '0';

	INSERT INTO upcomingEvents
	select distinct ci."Business_Id" BusinessId
	,ul."Created_Date" CreatedDate
	from "Upcoming_Live_Stream" ul
	join "Channel_Info" ci on ul."Channel_Id" = ci."Channel_Id"
	where ul."Is_Private_Event" = '0'
	and "Start_Date_Time" > NOW();

	RETURN QUERY

	 select  b."Business_Name" BusinessName
	  ,b."Business_Image" BusinessImage
	  ,b."Shortname" Shortname
	  ,b."Background_Image" BackgroundImage
	  ,f."FollowersCount"
	  ,b."Business_Id"  BusinessId
	from "Business" b
	join upcomingEvents u on b."Business_Id" = u.BusinessId
	left join (select f."Business_Id"
	,COUNT(f."UserId") FollowersCount
	  from "Follower" f
	  join upcomingEvents u on f."Business_Id" = u.BusinessId
	  group by f."Business_Id") f on u.BusinessId = f."Business_Id"
	group by  b."Business_Name"
	  ,b."Business_Image"  
	  ,b."Shortname"
	  ,b."Background_Image"
	  ,f."FollowersCount"
	  ,b."Business_Id"  
	Order by MAX(u.CreatedDate) desc;

	 drop table upcomingEvents;
END;
$$;