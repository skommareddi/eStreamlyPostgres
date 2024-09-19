CREATE OR REPLACE FUNCTION public.geteventpollbuyinfo(
	uniqueid character varying,
	refcursor1 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

DECLARE startDate timestamp; endDate timestamp;
BEGIN

select "Start_Date_Time"
INTO startDate
from "Upcoming_Live_Stream"
where "Media_Unique_Id" = uniqueId;

select "End_Date_Time"
INTO endDate
from "Upcoming_Live_Stream"
where "Media_Unique_Id" = uniqueId;

DROP TABLE IF EXISTS customerorder;
CREATE TEMP TABLE customerorder AS
select co."Product_Id"
		,SUM(co."Quantity") soldcount
from "Customer_Order" co 
left join "Live_Stream_Info" ls on co."Live_Unique_Id" = ls."Unique_Id" --or co.Live_Unique_Id = ls.Upcoming_Unique_Id
where uniqueId = ls."Unique_Id" or uniqueId= ls."Upcoming_Unique_Id"
group by co."Live_Unique_Id",co."Product_Id";

DROP TABLE IF EXISTS discount;
CREATE TEMP TABLE discount AS
select d.*
	  ,ROW_NUMBER() over(partition by d."Product_Id" order by d."Created_Date" desc) rn
from "Discount_Offer" d
where "Valid_End_Date" >= startDate and "Valid_Start_Date" <= endDate;

DROP TABLE IF EXISTS coupon;
CREATE TEMP TABLE coupon AS
select *
	  ,ROW_NUMBER() over(partition by dc."Product_Id" order by dc."Created_Date" desc) rn
from "Discount_Coupon" dc 
where "Valid_End_Date" >= startDate and "Valid_Start_Date" <= endDate;
	
	OPEN refcursor1 FOR 
	select  poll."ChannelId" "ChannelId" 
		  		,poll."PollUniqueId" "PollUniqueId"
		  	    ,poll."ProductId" :: bigint "ProductId"
		        ,poll."Name" "Name"
		  		,poll."ItemUrl" "ItemUrl"
		  		,poll."Description" "Description"
		  		,poll."Price1" :: decimal "Price"
				,poll."IsPollPosted" "IsPollPosted"
				,poll."Poll_Info_Id" "Poll_Info_Id"
				,poll."Upcoming_Poll_Info_Id" "Upcoming_Poll_Info_Id"
			,COALESCE(co.soldcount,0) "SoldCount"
			,d.*
			,c."Discount_Coupon_Id" "DiscountCouponId"
			,c."Coupon_Code" "CouponCode"
			,c."Discount_Percentage" "DiscountPercentage"
			,c."Product_Id" "CouponProduct"
			,c."Valid_Start_Date" "ValidStartDate" 
			,c."Valid_End_Date" "ValidEndDate" 	
			,poll."PollDate"
	from (select poll.*
			,ROW_NUMBER() OVER (PARTITION BY poll."ProductId" ORDER BY poll."Poll_Info_Id" DESC) "rno"
		from (select distinct  pi."Poll_Info_Detail" :: json->> 'ChannelId' as "ChannelId"
							  ,pi."Poll_Info_Detail" :: json->> 'PollUniqueId' as "PollUniqueId"
							  ,pi."Poll_Info_Detail" :: json->> 'ProductId' as "ProductId"
							  ,pi."Poll_Info_Detail" :: json->'Item'->>'Name' as "Name"
   		 					  ,pi."Poll_Info_Detail" :: json->'Item'->>'ItemUrl' as "ItemUrl"
			  				  ,pi."Poll_Info_Detail" :: json->'Item'->>'Description'as  "Description"
			  				  ,coalesce(pv."Price" :: text ,pi."Poll_Info_Detail" :: json->'Item'->>'Price') as "Price1"
							,true "IsPollPosted"
							,pi."Poll_Info_Id" "Poll_Info_Id"
							, 0 "Upcoming_Poll_Info_Id"
			  				, pi."Modified_Date" "PollDate"
			from "Poll_Info" pi 
			  left join "Product_Variant_List" pv on pi."Product_Variant_List_Id" = pv."Product_Variant_List_Id"
	where pi."Unique_Id" = uniqueId
		and pi."Poll_Type" = 2
	UNION
	select  distinct pi."Poll_Info_Detail" :: json->> 'ChannelId' as "ChannelId"
					  ,pi."Poll_Info_Detail" :: json->> 'UpcomingUniqueId' as "PollUniqueId"
					  ,pi."Poll_Info_Detail" :: json->> 'ProductId' as "ProductId"
					  ,pi."Poll_Info_Detail" :: json->'Item'->>'Name' as "Name"
					  ,pi."Poll_Info_Detail" :: json->'Item'->>'ItemUrl' as "ItemUrl"
					  ,pi."Poll_Info_Detail" :: json->'Item'->>'Description' as "Description"
					  ,coalesce(pv."Price"  :: text,pi."Poll_Info_Detail" :: json->'Item'->>'Price') as "Price1"
					,pi."Is_Poll_Posted" "IsPollPosted"
					,0 "Poll_Info_Id"
					,pi."Upcoming_Poll_Info_Id"
			  		, pi."Modified_Date" "PollDate"
	from "Upcoming_Poll_Info" pi 
			  left join "Product_Variant_List" pv on pi."Product_Variant_List_Id" = pv."Product_Variant_List_Id"
	where pi."Upcoming_Unique_Id" = uniqueId
		and pi."Poll_Type" = 2 
		and pi."Is_Poll_Posted" = false)poll) poll 
	left join customerorder co on poll."ProductId" :: bigint = co."Product_Id"
	left join discount d on poll."ProductId" :: bigint = d."Product_Id"
				and (d.rn is null or d.rn = 1)
	left join coupon c on Poll."ProductId" :: bigint = c."Product_Id"
				and (c.rn is null or c.rn = 1)
	where Poll.rno = 1
	and poll."ProductId" :: bigint > 0;
	RETURN NEXT refcursor1;

END;
$BODY$;

