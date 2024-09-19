CREATE OR REPLACE FUNCTION public.fn_get_user_behaviour_data(
	businessid bigint,
	fromdate timestamp without time zone,
	todate timestamp without time zone,
	pagenumber integer,
	pagesize integer,
	ref1 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

BEGIN
	
DROP TABLE IF EXISTS User_Engagement;
CREATE TEMP TABLE User_Engagement AS
select DATE(up."Created_Date") "Created_Date"
	  ,u."Email"
	  ,u."PhoneNumber"
	  ,COALESCE (u."FullName" , gu."Guest_User_Name",('Guest - ' || up."Guest_User_Id")) "Name"
	  ,up."UserId"
	  ,up."Guest_User_Id"
	  ,up."Keyword"
	  ,up."Type"
	  ,up."Description"
	  ,up."Product_Id_List"
	  ,up."HostUrl"
	  ,COALESCE(uls."Name",vc."Title",'Instant Live') "EventName"
	  ,up."UniqueId"
	  ,up."Event"
	  ,up."Browser_Info"
	  ,up."Device_Info"
from "User_Participation_Details" up 
left join "AspNetUsers" u on up."UserId" = u."Id"
left join "Guest_User" gu on up."Guest_User_Id" = gu."Guest_User_Id"
LEFT JOIN "MediaByUserAndChannel" mbuc ON up."UniqueId" = mbuc."Media_Unique_Id"
LEFT JOIN "Live_Stream_Info" ls ON up."UniqueId" = ls."Unique_Id"
LEFT JOIN "Upcoming_Live_Stream" uls ON mbuc."Media_Unique_Id" = uls."Media_Unique_Id"
LEFT JOIN "Channel_Info" ci ON ls."Channel_Info_Id" = ci."Channel_Info_Id"
LEFT JOIN "Business" b ON ci."Business_Id" = b."Business_Id"
LEFT JOIN "Video_Channel" vc ON up."UniqueId" = vc."Video_Unique_Id"
where COALESCE(b."Business_Id" , vc."Business_Id") = businessId
and up."Created_Date" between fromdate and todate;

DROP TABLE IF EXISTS result_set;
CREATE TEMP TABLE result_set AS
select distinct u."Created_Date" "Date"
,u."UniqueId"
	   ,u."EventName"
	   ,u."Email"
	   ,u."PhoneNumber"
	   ,u."Name"
	   ,COALESCE(i."TotalInteraction",0) "TotalInteraction"
	   ,COALESCE(s. "ShareCount",0) "ShareCount"
	   ,COALESCE(l."LikeCount",0) "LikeCount"
	   ,det."UserSource"
	   ,Case when es."MarkettingOptIn" = 'Yes' then 'Yes' else 'No' end "MarkettingOptIn"
	   ,det."Product_Name" "ProductName"
	   ,det."AllProductsOpen"
	   ,det."ProductView"
	   ,det."AddToCart"
	   ,det."ViewCheckout"
	   ,det."Checkout"	
	   , bro."Browser"
from  (select distinct u."Created_Date"
					,COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id") AS "UserId"
					,u."Email"
					,u."PhoneNumber"
					,"Name"
					,"EventName"
					,"UniqueId"
			from User_Engagement u
			where COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id") != '') u
left join (SELECT  "UserId",
				   "ProductId",
				   "Product_Name",
		   		   "UniqueId",
				   max("UserSource") "UserSource",
		           (CASE WHEN SUM("AllProductsOpen") >0  THEN 'Yes' ELSE 'No' END) AS "AllProductsOpen",
		   		   (CASE WHEN SUM("ProductViewed") > 0  THEN 'Yes' ELSE 'No' END) AS "ProductView",
  				   (CASE WHEN SUM("AddedToCart") > 0 THEN 'Yes' ELSE 'No' END) AS "AddToCart",
   				   (CASE WHEN SUM("InitiatedCheckout") > 0 THEN 'Yes' ELSE 'No' END) AS "ViewCheckout",
                   (CASE WHEN SUM("CompletedCheckout") >0  THEN 'Yes' ELSE 'No' END) AS "Checkout"		           
		  FROM ( SELECT
        d.value::bigint AS "ProductId",
        p."Product_Name",
        COALESCE(NULLIF("UserId", ''), "Guest_User_Id") AS "UserId",
        COALESCE("HostUrl", 'estreamly watchpage') AS "UserSource",
        "Keyword",
        "Type",
        "UniqueId",
        "Event",
        CASE
            WHEN "Keyword" IN ('all_products_productclick', 'buy_now', 'digital_tip', 'product_buynow')
                AND "Type" = 'product'   
				OR ("Keyword" = 'product_buynow' AND "Type" = 'product')
				OR "Keyword" = 'product_addtocart'
                OR ("Keyword" = 'product_buynow' AND "Type" = 'product')
                OR ("Keyword" = 'product_guestcheckout' AND "Type" = 'product')
				OR "Keyword" = 'checkout_complete' 
				OR "Keyword" = 'product_guestcheckout'
				OR "Keyword" = 'product_buynow'THEN 1
            ELSE 0
        END AS "ProductViewed",
        CASE
            WHEN "Keyword" = 'product_addtocart'
                OR ("Keyword" = 'product_buynow' AND "Type" = 'product')
                OR ("Keyword" = 'product_guestcheckout' AND "Type" = 'product')
				OR "Keyword" = 'checkout_complete' 
				OR "Keyword" = 'product_guestcheckout'
				OR "Keyword" = 'product_buynow' THEN 1
            ELSE 0
        END AS "AddedToCart",
        CASE
            WHEN "Keyword" = 'checkout_complete' 
				OR "Keyword" = 'product_guestcheckout'
				OR "Keyword" = 'product_buynow' THEN 1
            ELSE 0
        END AS "InitiatedCheckout",
        CASE
            WHEN "Keyword" = 'checkout_complete' THEN 1
            ELSE 0
        END AS "CompletedCheckout",
		CASE
            WHEN "Keyword" = 'all_products_open' THEN 1
            ELSE 0
        END AS "AllProductsOpen"
    FROM
        User_Engagement up
    CROSS JOIN LATERAL json_array_elements_text("Product_Id_List"::json) d
    LEFT JOIN "Product" p ON d.value::bigint = p."Product_Id"	
-- 				where ("Keyword" = 'buy_now' 
-- 					  or "Keyword" = 'all_products_productclick' 
-- 					  or "Keyword" = 'product_addtocart'
-- 					  or ("Keyword" like 'product_buynow' and "Type" = 'product') 
-- 					  or "Keyword" = 'product_guestcheckout'
-- 					  or "Keyword" = 'checkout_complete')
			   ) s
		  GROUP BY  "UserId","ProductId","Product_Name","UniqueId") det on u."UserId" = det."UserId" and u."UniqueId" = det."UniqueId"
left join (select COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id") "UserId"
		   		, Count(*) "LikeCount"
		   	    , "UniqueId"
			from User_Engagement u
			where "Type" like 'like'
		  group by COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id"),"UniqueId") l on u."UserId" = l."UserId" and u."UniqueId" = l."UniqueId"
left join (select COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id") "UserId"
		   		 ,Count(*) "ShareCount"
		   		 ,"UniqueId"
			from User_Engagement u
			where "Type" like '%share%'
		    group by COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id"),"UniqueId") s on  u."UserId" = s."UserId" and u."UniqueId" = s."UniqueId"
left join (select COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id") "UserId" 
		   		  ,Count(*) "TotalInteraction"
		   		  ,"UniqueId"
			from User_Engagement u
		    Where "Event" like 'click'
			group by COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id"),"UniqueId") i on u."UserId" = i."UserId" and u."UniqueId" = i."UniqueId"
left join (select u."UserId"
				  ,Case when ue."Marketting_Email_Fl" = true then 'Yes' else 'No' end "MarkettingOptIn"
			from User_Engagement u 
			left join "User_Email_Subscription" ue on  u."UserId" = ue."UserId"	   
			where  ue."Upcoming_Unique_Id" is null) es on u."UserId" = es."UserId"
	left join (select COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id") "UserId"
		   		, "Browser_Info" AS "Browser"
-- 			   , "Browser_Info" || ' (' || ("Device_Info"::jsonb->> 'deviceType') || ')' AS "Browser"
		   	    , "UniqueId"
			from User_Engagement u
			where "Type" like 'like'
		  group by COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id"),"UniqueId", "Browser_Info" ) bro on u."UserId" = bro."UserId" and u."UniqueId" = bro."UniqueId"
-- 		   group by COALESCE(NULLIF(u."UserId", ''), u."Guest_User_Id"),"UniqueId", "Browser_Info" || ' (' || ("Device_Info"::jsonb->> 'deviceType') || ')') bro on u."UserId" = bro."UserId" and u."UniqueId" = bro."UniqueId"
ORDER BY u."Created_Date" desc;

OPEN ref1 FOR
select r.*
-- 	  ,s."TotalCount"
from result_set r
-- cross join (select count(*) "TotalCount" from result_set) s
LIMIT CASE WHEN pagesize = 0 THEN NULL ELSE pagesize END
OFFSET CASE WHEN pagesize = 0 THEN 0 ELSE (pagenumber - 1) * pagesize END;
RETURN NEXT ref1;

END;
$BODY$;
