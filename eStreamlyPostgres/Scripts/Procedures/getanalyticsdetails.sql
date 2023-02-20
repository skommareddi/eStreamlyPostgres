
CREATE OR REPLACE FUNCTION public.getanalyticsdetails(
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

BEGIN
OPEN ref FOR 	 
select up."UniqueId"
	  ,ul."Name" EventName
	  ,ul."Description" EventDesc
	  ,MAX(m."DurationInSeconds") Duration
	  ,MAX(ls."Viewer_Count") ViewCount
	  ,COUNT(up."UserId") EngagementCount
	  ,MAX(coalesce(co.orderCount,0)) OrderCount
	  ,CAST(MAX(coalesce(TotalRevenue,0)) / 100  as decimal(10,2)) Revenue
	  ,MAX(u."FullName") EventHost
	  ,MAX(coalesce(b.BuyClicks,0)) BuyClicks
	  ,MAX(eu.EngagedUsers) EngagedUsers
from "Upcoming_Live_Stream" ul 
join "Live_Stream_Info" ls on ul."Media_Unique_Id" = ls."Unique_Id"
join "User_Participation_Details" up on ls."Unique_Id" = up."UniqueId"
join "AspNetUsers" u on ul."User_Id" = u."Id"
left join (select "Live_Unique_Id"
				 ,SUM(co."Quantity") orderCount 
				 ,SUM("Amount") TotalRevenue
		   from  "Customer_Order" co
		   group by "Live_Unique_Id") co on ls."Unique_Id" = co."Live_Unique_Id" 
Left join (Select "UniqueId"
				 ,SUM(BuyClicks) BuyClicks 
			from (select "UniqueId"
						 ,COUNT("Payment_Method") BuyClicks
					from "User_Participation_Details" 
					where  "Type" ='buyClick'
					group by "UniqueId","Payment_Method") a
			group by "UniqueId") b on ls."Unique_Id" = b."UniqueId"
left join (select "UniqueId"
				  ,count(EngagedUsers) EngagedUsers
			from (select "UniqueId"
						,"UserId" EngagedUsers
				  from "User_Participation_Details"  up 
				  join "AspNetUsers" au on up."UserId" = au."Id"
				  where "Type" = 'engage'
				  group by "UniqueId","UserId") p
			group by "UniqueId") eu on ls."Unique_Id" = eu."UniqueId"
left join "MediaByUserAndChannel" m on ls."Unique_Id" = m."Media_Unique_Id"
where "Type" = 'engage'
group by up."UniqueId"
		,ul."Name"
		,ul."Description"
		,co."Live_Unique_Id";
RETURN ref;
END
$BODY$;

