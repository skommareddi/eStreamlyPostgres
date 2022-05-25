-- FUNCTION: public.geteventpollinfo(character varying, refcursor, refcursor)

-- DROP FUNCTION IF EXISTS public.geteventpollinfo(character varying, refcursor, refcursor);

CREATE OR REPLACE FUNCTION public.geteventpollinfo(
	uniqueid character varying,
	refcursor1 refcursor,
	refcursor2 refcursor)
   
    RETURNS SETOF refcursor AS $$
DECLARE startDate timestamp;endDate timestamp;
BEGIN
DROP TABLE IF EXISTS PollResult;
CREATE temp table PollResult
(
	Question varchar ,
	Options  varchar ,
	SelectedOption  varchar null,
	RespondCount bigint null,
	PollInfoId bigint null,
	ChannelId varchar(250) null ,
	PollUniqueId varchar(250) null,
	PollType int null,
	Information varchar null,
	ShoutOutValue varchar null
);

DROP TABLE IF EXISTS UpcomingPollResult;
CREATE TEMP TABLE UpcomingPollResult
(
	Question varchar ,
	Options  varchar,	
	PollInfoId bigint null,
	ChannelId varchar(250) null ,
	PollUniqueId varchar(250) null,
	PollType int null,
	Information varchar,
	ShoutOutValue varchar,
	Product_Id bigint null,
	Is_Poll_Posted bit 
);

DROP TABLE IF EXISTS poll;
CREATE TEMP TABLE poll AS
select * 
from (select pi."Poll_Info_Detail"
			  ,pi."Poll_Info_Id"
			  ,pi."Poll_Info_Detail" :: json->> 'Description' as "Question"
	  		  ,pi."Poll_Info_Detail" :: json->> 'Options' as "Options"
	          ,pi."Poll_Info_Detail" :: json->> 'ChannelId' as "ChannelId"
	  		  ,pi."Poll_Info_Detail" :: json->> 'PollUniqueId' as "PollUniqueId"
			  ,pr."SelectedOption"
			  ,DENSE_RANK() over (partition by (pi."Poll_Info_Detail" :: json->> 'Description') order by pi."Poll_Info_Id" asc ) rn
			  ,pi."Poll_Type" "PollType"
		from "Poll_Info" pi
left join(select  pr."Response_Info" :: json->'QuestionResponse'->>'SelectedOption' as "SelectedOption"
				,pr."Poll_Info_Id" 
			from  "Poll_Responses" pr --on pi.Poll_Info_Id = pr.Poll_Info_Id
		 ) pr on pi."Poll_Info_Id" = pr."Poll_Info_Id"
where "Unique_Id" = uniqueId
and pi."Poll_Type" = 1) p
order by p."Poll_Info_Id";

DROP TABLE IF EXISTS pollques1;
CREATE TEMP TABLE pollques1 AS
select "Question"
		,p."Poll_Info_Detail" :: json->>'Options' as "Options"
from poll p;

DROP TABLE IF EXISTS pollques;
CREATE TEMP TABLE pollques AS
select pi."Question"
	   ,c.value "Options",c.ordinality
from pollques1 pi
cross join json_array_elements_text(pi."Options" :: json) with ordinality c
group by pi."Question",c.value,c.ordinality
order by pi."Question",c.value,c.ordinality;

DROP TABLE IF EXISTS pollquesResult;
CREATE TEMP TABLE pollquesResult AS
select pq.*
	  ,p."SelectedOption"
	  ,COALESCE(p."RespondCount",0) "RespondCount"
from pollques pq 
left join (select "Question"
				 ,"SelectedOption"
				 ,Count(*) "RespondCount"
			from poll p
			where "Question" is not null
			group by "Question"
					,"SelectedOption"
			) p on pq."Question" = p."Question" and pq."Options" = p."SelectedOption";

INSERT INTO PollResult(Question
					   ,Options
					   ,SelectedOption
					   ,RespondCount)
select  "Question"
	   ,"Options"
	   ,"SelectedOption"
	   ,"RespondCount"
from pollquesResult;

update PollResult  set PollInfoId = p."Poll_Info_Id"
					 ,ChannelId = p."ChannelId"
					 ,PollUniqueId = p."PollUniqueId"
					 ,PollType = p."PollType"
--select *
from poll p 
left join PollResult pr on pr.Question = p."Question"-- and pr.Options = p.SelectedOption 
where p.rn = 1;

DROP TABLE IF EXISTS PollInfoResult;
CREATE TEMP TABLE PollInfoResult AS
select pi."Poll_Info_Detail"
	  ,pi."Poll_Info_Id" "PollInfoId"
	   ,pi."Poll_Info_Detail" :: json->> 'Information' as "Information"
	  		  ,pi."Poll_Info_Detail" :: json->> 'ChannelId' as "ChannelId"
	          ,pi."Poll_Info_Detail" :: json->> 'PollUniqueId' as "PollUniqueId"
	  ,pi."Poll_Type" "PollType"
from "Poll_Info" pi
where "Unique_Id" = uniqueId
and pi."Poll_Type" = 3
order by pi."Poll_Info_Id";

INSERT INTO PollResult(ChannelId,PollInfoId,PollType,PollUniqueId,Information)
select "ChannelId",pr."PollInfoId",pr."PollType","PollUniqueId","Information" from PollInfoResult pr;

DROP TABLE IF EXISTS PollShoutResult;
CREATE TEMP TABLE PollShoutResult AS
select pi."Poll_Info_Detail"
	  ,pi."Poll_Info_Id" "PollInfoId"
	    ,pi."Poll_Info_Detail" :: json->> 'ShoutOutValue' as "ShoutOutValue"
	  		  ,pi."Poll_Info_Detail" :: json->> 'ChannelId' as "ChannelId"
	          ,pi."Poll_Info_Detail" :: json->> 'PollUniqueId' as "PollUniqueId"
	  ,pi."Poll_Type" "PollType"
from "Poll_Info" pi
where "Unique_Id" = uniqueId
and pi."Poll_Type" = 5
order by pi."Poll_Info_Id";

INSERT INTO PollResult(ChannelId,PollInfoId,PollType,PollUniqueId,ShoutOutValue)
select "ChannelId","PollInfoId","PollType","PollUniqueId","ShoutOutValue" from PollShoutResult;

DROP TABLE IF EXISTS upcomingpoll1;
CREATE TEMP TABLE upcomingpoll1 AS
select * 
from (select pi."Poll_Info_Detail"
			  ,pi."Upcoming_Poll_Info_Id"
			   ,pi."Poll_Info_Detail" :: json->> 'Description' as "Question"
	  		  ,pi."Poll_Info_Detail" :: json->> 'ChannelId' as "ChannelId"
	          ,pi."Poll_Info_Detail" :: json->> 'PollUniqueId' as "PollUniqueId"
			  ,pi."Poll_Type" "PollType"
			   ,pi."Poll_Info_Detail" :: json->> 'Options' as "Options1"
			  ,pi."Upcoming_Unique_Id"
			  ,pi."Product_Id"
			  ,CASE WHEN  "Is_Poll_Posted"  THEN 1 ELSE 0 END  :: bit "Is_Poll_Posted"
		from "Upcoming_Poll_Info" pi
where "Upcoming_Unique_Id" = uniqueId 
	and pi."Poll_Type" = 1 
	and "Is_Poll_Posted" = false
) p
order by p."Upcoming_Poll_Info_Id";

DROP TABLE IF EXISTS upcomingpoll;
CREATE TEMP TABLE upcomingpoll AS
select pi.*
	   ,c.value "Options"
from upcomingpoll1 pi
cross join json_array_elements_text(pi."Options1" :: json) with ordinality c
-- group by pi."Question",c.value,c.ordinality
order by pi."Question",c.value,c.ordinality;

INSERT INTO UpcomingPollResult (
						Question
					   ,Options
					   ,PollInfoId
					   ,PollType
					   ,PollUniqueId
					   ,ChannelId
					   ,Product_Id
					   ,Is_Poll_Posted)
select  "Question"
	   ,"Options"
	   ,"Upcoming_Poll_Info_Id"
		,"PollType"
		,"Upcoming_Unique_Id"
		,"ChannelId"
		,"Product_Id"
		,"Is_Poll_Posted"
from upcomingpoll;

DROP TABLE IF EXISTS UpcomingInfo;
CREATE TEMP TABLE UpcomingInfo AS
select pi."Poll_Info_Detail"
	  ,pi."Upcoming_Poll_Info_Id" "PollInfoId"
	    ,pi."Poll_Info_Detail" :: json->> 'Information' as "Information"
	  		  ,pi."Poll_Info_Detail" :: json->> 'ChannelId' as "ChannelId"
	          ,pi."Poll_Info_Detail" :: json->> 'PollUniqueId' as "PollUniqueId"
	  ,pi."Poll_Type" "PollType"
	  ,pi."Upcoming_Unique_Id"
	  ,CASE WHEN  "Is_Poll_Posted"  THEN 1 ELSE 0 END  :: bit "Is_Poll_Posted"
from "Upcoming_Poll_Info" pi
where "Upcoming_Unique_Id" = uniqueId
	 and pi."Poll_Type" = 3
	 and "Is_Poll_Posted" = false
order by pi."Upcoming_Poll_Info_Id";

INSERT INTO UpcomingPollResult(ChannelId,PollInfoId,PollType,PollUniqueId,Information,Is_Poll_Posted)
select "ChannelId","PollInfoId","PollType","Upcoming_Unique_Id","Information","Is_Poll_Posted" from UpcomingInfo;

DROP TABLE IF EXISTS UpcomingShoutout;
CREATE TEMP TABLE UpcomingShoutout AS
select pi."Poll_Info_Detail"
	  ,pi."Upcoming_Poll_Info_Id" "PollInfoId"
	   ,pi."Poll_Info_Detail" :: json->> 'ShoutOutValue' as "ShoutOutValue"
	  		  ,pi."Poll_Info_Detail" :: json->> 'ChannelId' as "ChannelId"
	          ,pi."Poll_Info_Detail" :: json->> 'PollUniqueId' as "PollUniqueId"
	  ,pi."Poll_Type" "PollType"
	  ,pi."Upcoming_Unique_Id"
	 ,CASE WHEN  "Is_Poll_Posted"  THEN 1 ELSE 0 END  :: bit "Is_Poll_Posted"
-- INTO UpcomingShoutout
from "Upcoming_Poll_Info" pi
where "Upcoming_Unique_Id" = uniqueId
	and pi."Poll_Type" = 5
	and "Is_Poll_Posted" = false
order by pi."Upcoming_Poll_Info_Id";

INSERT INTO UpcomingPollResult(ChannelId,PollInfoId,PollType,PollUniqueId,ShoutOutValue,Is_Poll_Posted)
select "ChannelId","PollInfoId","PollType","Upcoming_Unique_Id","ShoutOutValue","Is_Poll_Posted" from UpcomingShoutout;

OPEN refcursor1 FOR
select * from PollResult;
RETURN NEXT refcursor1 ; 

OPEN refcursor2 FOR
select * from UpcomingPollResult;
RETURN NEXT refcursor2;

END;
$$ LANGUAGE plpgsql;

