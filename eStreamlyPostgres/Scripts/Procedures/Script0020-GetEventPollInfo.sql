CREATE PROCEDURE [dbo].[GetEventPollInfo](@uniqueId varchar(50))
AS
BEGIN
CREATE table #PollResult
(
	Question nvarchar(max)null,
	Options  nvarchar(max) null,
	SelectedOption  nvarchar(max) null,
	RespondCount bigint null,
	PollInfoId bigint null,
	ChannelId varchar(250) null ,
	PollUniqueId varchar(250) null,
	PollType int null,
	Information varchar(max) null,
	ShoutOutValue varchar(max) null
)

CREATE table #UpcomingPollResult
(
	Question nvarchar(max)null,
	Options  nvarchar(max) null,	
	PollInfoId bigint null,
	ChannelId varchar(250) null ,
	PollUniqueId varchar(250) null,
	PollType int null,
	Information varchar(max) null,
	ShoutOutValue varchar(max) null,
	Product_Id bigint null,
	Is_Poll_Posted bit 
)


select * 
into #poll
from (select pi.Poll_Info_Detail
			  ,pi.Poll_Info_Id
			  ,c.*
			  ,pr.SelectedOption
			  ,DENSE_RANK() over (partition by c.Question order by pi.poll_info_id asc ) rn
			  ,pi.Poll_Type PollType
		from Poll_Info pi
		Cross apply
						OPENJSON(pi.poll_info_detail)
						WITH (
							Question varchar(1000) '$.Description',	
							Options NVARCHAR(max) '$.Options' as json,
							ChannelId varchar(250) '$.ChannelId',
							PollUniqueId varchar(250) '$.PollUniqueId'
				) c
left join(select cr.*
				,pr.poll_info_id 
			from  Poll_Responses pr --on pi.Poll_Info_Id = pr.Poll_Info_Id
cross apply OPENJSON(pr.Response_Info)
				WITH (
					SelectedOption varchar(500) '$.QuestionResponse.SelectedOption'
				) cr) pr on pi.Poll_Info_Id = pr.Poll_Info_Id
where Unique_Id = @uniqueId
and pi.Poll_Type = 1) p
order by p.Poll_Info_Id

select question
	  ,c.options
INTO #pollques
from #poll p
cross apply OPENJSON(p.poll_info_detail,'$.Options')
WITH( 
Options VARCHAR(20) '$' ) c
group by question,c.options

select pq.*
	  ,p.SelectedOption
	  ,ISNULL(p.RespondCount,0) RespondCount
INTO #pollquesResult
from #pollques pq 
left join (select Question
				 ,SelectedOption
				 ,Count(*) RespondCount
			from #poll p
			where question is not null
			group by Question
					,SelectedOption
			) p on pq.Question = p.question and pq.options = p.selectedoption

insert into #PollResult(
						Question
					   ,Options
					   ,SelectedOption
					   ,RespondCount)
select  Question
	   ,Options
	   ,SelectedOption
	   ,RespondCount
from #pollquesResult

update pr set PollInfoId = p.Poll_Info_Id
			 ,ChannelId = p.ChannelId
			 ,PollUniqueId = p.PollUniqueId
			 ,PollType = p.PollType
--select *
from #poll p 
left join #PollResult pr on pr.Question = p.Question-- and pr.Options = p.SelectedOption 
where p.rn = 1

select pi.Poll_Info_Detail
	  ,pi.Poll_Info_Id PollInfoId
	  ,c.*
	  ,pi.Poll_Type PollType
INTo #PollInfoResult
from Poll_Info pi
Cross apply
				OPENJSON(pi.poll_info_detail)
				WITH (
					Information varchar(1000) '$.Information',	
					ChannelId varchar(250) '$.ChannelId',
					PollUniqueId varchar(250) '$.PollUniqueId'
				) c
where Unique_Id = @uniqueId
and pi.Poll_Type = 3
order by pi.Poll_Info_Id

INSERT INTO #PollResult(ChannelId,PollInfoId,PollType,PollUniqueId,Information)
select ChannelId,PollInfoId,PollType,PollUniqueId,Information from #PollInfoResult

select pi.Poll_Info_Detail
	  ,pi.Poll_Info_Id PollInfoId
	  ,c.*
	  ,pi.Poll_Type PollType
INTO #PollShoutResult
from Poll_Info pi
Cross apply
				OPENJSON(pi.poll_info_detail)
				WITH (
					ShoutOutValue varchar(1000) '$.ShoutOutValue',	
					ChannelId varchar(250) '$.ChannelId',
					PollUniqueId varchar(250) '$.PollUniqueId'
				) c
where Unique_Id = @uniqueId
and pi.Poll_Type = 5
order by pi.Poll_Info_Id

INSERT INTO #PollResult(ChannelId,PollInfoId,PollType,PollUniqueId,ShoutOutValue)
select ChannelId,PollInfoId,PollType,PollUniqueId,ShoutOutValue from #PollShoutResult

select * 
into #upcomingpoll
from (select pi.Poll_Info_Detail
			  ,pi.Upcoming_Poll_Info_Id
			  ,c.*
			  ,pi.Poll_Type PollType
			  ,cq.*
			  ,pi.Upcoming_Unique_Id
			  ,pi.Product_Id
			  ,Is_Poll_Posted 
		from Upcoming_Poll_Info pi
		Cross apply
						OPENJSON(pi.poll_info_detail)
						WITH (
							Question varchar(1000) '$.Description',	
							ChannelId varchar(250) '$.ChannelId',
							PollUniqueId varchar(250) '$.PollUniqueId'
				) c
	cross apply OPENJSON(pi.poll_info_detail,'$.Options')
		WITH( 
		Options VARCHAR(20) '$' ) cq
where Upcoming_Unique_Id = @uniqueId 
	and pi.Poll_Type = 1 
	and Is_Poll_Posted = 0
) p
order by p.Upcoming_Poll_Info_Id

insert into #UpcomingPollResult(
						Question
					   ,Options
					   ,PollInfoId
					   ,PollType
					   ,PollUniqueId
					   ,ChannelId
					   ,Product_Id
					   ,Is_Poll_Posted)
select  Question
	   ,Options
	   ,Upcoming_Poll_Info_Id
		,PollType
		,Upcoming_Unique_Id
		,ChannelId
		,Product_Id
		,Is_Poll_Posted
from #upcomingpoll

select pi.Poll_Info_Detail
	  ,pi.Upcoming_Poll_Info_Id PollInfoId
	  ,c.*
	  ,pi.Poll_Type PollType
	  ,pi.Upcoming_Unique_Id
	  ,Is_Poll_Posted
INTO #UpcomingInfo
from Upcoming_Poll_Info pi
Cross apply
				OPENJSON(pi.poll_info_detail)
				WITH (
					Information varchar(1000) '$.Information',	
					ChannelId varchar(250) '$.ChannelId',
					PollUniqueId varchar(250) '$.PollUniqueId'
				) c
where Upcoming_Unique_Id = @uniqueId
	 and pi.Poll_Type = 3
	 and Is_Poll_Posted = 0
order by pi.Upcoming_Poll_Info_Id

INSERT INTO #UpcomingPollResult(ChannelId,PollInfoId,PollType,PollUniqueId,Information,Is_Poll_Posted)
select ChannelId,PollInfoId,PollType,Upcoming_Unique_Id,Information,Is_Poll_Posted from #UpcomingInfo


select pi.Poll_Info_Detail
	  ,pi.Upcoming_Poll_Info_Id PollInfoId
	  ,c.*
	  ,pi.Poll_Type PollType
	  ,pi.Upcoming_Unique_Id
	  ,Is_Poll_Posted
INTO #UpcomingShoutout
from Upcoming_Poll_Info pi
Cross apply
				OPENJSON(pi.poll_info_detail)
				WITH (
					ShoutOutValue varchar(1000) '$.ShoutOutValue',	
					ChannelId varchar(250) '$.ChannelId',
					PollUniqueId varchar(250) '$.PollUniqueId'
				) c
where Upcoming_Unique_Id = @uniqueId
	and pi.Poll_Type = 5
	and Is_Poll_Posted = 0
order by pi.Upcoming_Poll_Info_Id

INSERT INTO #UpcomingPollResult(ChannelId,PollInfoId,PollType,PollUniqueId,ShoutOutValue,Is_Poll_Posted)
select ChannelId,PollInfoId,PollType,Upcoming_Unique_Id,ShoutOutValue,Is_Poll_Posted from #UpcomingShoutout

select * from #PollResult
select * from #UpcomingPollResult

drop table #poll
drop table #pollques
drop table #pollquesResult
drop table #PollResult
drop table #PollInfoResult
drop table #PollShoutResult

drop table #UpcomingPollResult
drop table #upcomingpoll
drop table #UpcomingInfo
drop table #UpcomingShoutout

END