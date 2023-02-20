
CREATE OR REPLACE FUNCTION public.getmechantdetails(
	shortname text,
	refcursor1 refcursor,
	refcursor2 refcursor,
	refcursor3 refcursor,
	refcursor4 refcursor,
	refcursor5 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

BEGIN

DROP TABLE IF EXISTS businessList;
CREATE TEMP TABLE businessList AS
select "Business_Id"
	  ,"UserName"
	  ,"Business_Name"
	  ,"Business_Description"
	  ,"Business_Url"
	  ,"Business_Image"
	  ,"User_Id"
	  ,"Shortname"
	  ,"Background_Image"
from "Business" b 
where Lower(b."Shortname") = Lower(shortName)
and b."Is_Active" = 'Y';

insert into businessList
select b."Business_Id"
	  ,b."UserName"
	  ,"Business_Name"
	  ,"Business_Description"
	  ,"Business_Url"
	  ,"Business_Image"
	  ,b."User_Id"
	  ,"Shortname"
	  ,"Background_Image"
from "Channel_Info" c
join "Business" b on c."Business_Id" = b."Business_Id"
join "User_Channel" uc on c."Channel_Info_Id" = uc."Channel_Info_Id"
join "AspNetUsers" u on uc."UserId" = u."Id"
where Lower(u."UserShortName") = Lower(shortName)
and b."Is_Active" = 'Y';

DROP TABLE IF EXISTS liveStream;
CREATE TEMP TABLE liveStream AS
select ls."Channel_Info_Id"
	  ,ls."Unique_Id"
	  ,ROW_NUMBER() OVER (PARTITION BY ls."Channel_Info_Id" ORDER BY ls."Created_Date" desc ) AS rn	  
	  ,ul."Event_Image" EventImage 
	  ,ul."Description" EventDesc
	  ,ul."Name" EventName
from "Live_Stream_Info" ls
left join "Upcoming_Live_Stream" ul on ls."Unique_Id" = ul."Media_Unique_Id"
group by ls."Channel_Info_Id"
		,"Unique_Id" 
		,ls."Created_Date"
		,ul."Event_Image" 
		,ul."Description"
		,ul."Name" ;

DROP TABLE IF EXISTS userChannels;
CREATE TEMP TABLE userChannels AS
select  ci."Channel_Id",
		ci."Channel_Info_Id",
		ci."Business_Id",
		uc."UserId",
		r."Name",
		ci."Channel_Name",
		ci."Channel_Desc",
		u."ImageUrl",
		u."ThumbnailImageUrl",
		b."Business_Name",
		b."Business_Image",
		b."Background_Image",
	    CASE WHEN  r."Name" like 'Channel Owner' THEN 1
		     WHEN r."Name" like 'Admin' THEN 2 END RoleNo,
	    ROW_NUMBER() OVER (PARTITION BY ci."Channel_Info_Id" ORDER BY ci."Channel_Info_Id" ) AS rn,
		ls."Unique_Id",
		ls.EventName,
		ls.EventDesc,
		ls.EventImage,
		b."Shortname"
from "Channel_Info" ci
join "Business" b on ci."Business_Id" = b."Business_Id"
join "User_Channel" uc on ci."Channel_Info_Id" = uc."Channel_Info_Id"
join "AspNetUserRoles" ur on uc."UserId" = ur."UserId"
join "AspNetRoles" r on ur."RoleId" = r."Id"
join "AspNetUsers" u on uc."UserId" = u."Id"
left join liveStream ls on ci."Channel_Info_Id" = ls."Channel_Info_Id" and ls.rn = 1
WHERE r."Name" in('Channel Owner','Admin')
and b."Is_Active" = 'Y';

DROP TABLE IF EXISTS userChannel;
CREATE TEMP TABLE userChannel AS
select uc."Channel_Info_Id" ChannelInfoId,
		uc."Channel_Id" ChannelId,		
		uc."UserId",
		uc."Business_Id" BusinessId,		
		uc."Channel_Desc" ChannelDesc,
		uc."Channel_Name" ChannelName,
		uc."ImageUrl" ImageUrl,
		uc."ThumbnailImageUrl" ThumbnailImageUrl,
	    uc."Business_Name" BusinessName,
	    uc."Business_Image" BusinessImage,
		uc."Background_Image" BackgroundImage,
		uc."Unique_Id" LiveUniqueId,
		uc.EventName,
		uc.EventDesc,
		uc.EventImage,
		uc."Shortname"
from userChannels uc 
join businessList bl on uc."Business_Id" = bl."Business_Id"
where rn = 1 
group by  "Channel_Id",
		"Channel_Info_Id",
		uc."Business_Id",
		"UserId",
		"Name",
		"Channel_Name",
		"Channel_Desc",
		"ImageUrl",
		"ThumbnailImageUrl",
	    uc."Business_Name",
	    uc."Business_Image",
		uc."Background_Image",
		RoleNo,
		"Unique_Id",
		EventName,
		EventDesc,
		EventImage,
		uc."Shortname";
--insert into #userChannel
--	EXEC (@query);

OPEN refcursor1 FOR
select e."Upcoming_Live_Stream_Id"
	    ,e."Name"
	    ,e."Description" Description
	    ,e."Channel_Id" ChannelId
	    ,e."Media_Unique_Id"
	    ,e."Start_Date_Time" StartDateTime
	    ,e."End_Date_Time" EndDateTime
	    ,e."User_Id"
	    ,e."Event_Image" EventImage
	    ,e."Desktop_Image_Url" DesktopImageUrl
	    ,e."Mobile_Image_Url" MobileImageUrl
	    ,e."Tablet_Image_Url" TabletImageUrl
	    ,u."ImageUrl" User_Profile_Image
	    ,u."ThumbnailImageUrl" User_Thumbnail_Image
		,uc.BusinessName
		,uc.BusinessImage
		,uc.BackgroundImage
		,uc.ChannelName
		,uc."Shortname" MerchantShortName
		,e."Name" EventName
		,e."Description" EventDesc
from "Upcoming_Live_Stream" e
join userChannel uc on e."Channel_Id" = uc.ChannelId
left join "AspNetUsers" u on e."User_Id" = u."Id"
left join "Live_Stream_Info" li on e."Media_Unique_Id" = COALESCE(li."Upcoming_Unique_Id",li."Unique_Id")
where "Start_Date_Time" >= Now()
and e."Is_Private_Event" = false
and (li."Live_Stream_Info_Id" is null or li."Live_Stream_Info_Id" = 0)
order by e."Start_Date_Time";
RETURN NEXT refcursor1;

OPEN refcursor2 FOR
select * from 
	(select  0 IsLive
			,ci."Channel_Id" ChannelId
			,ci."Channel_Name" ChannelName
			,m."Media_Item_Id"
			,m."User_Id" 
			,m."Media_Url" Media_Url 
			,COALESCE(m."Uploaded_Event_Thumbnail_Image_Url",m."Media_thumbnail_Url") Media_thumbnailUrl
			,m."Media_thumbnailGif_Url" Media_thumbnailGifUrl
			,m."CreatedDate"
			,u."ImageUrl" User_Profile_Image
			,u."ThumbnailImageUrl" User_Thumbnail_Image
			,m."Channel_Desc" ChannelDesc
			,m."Media_Unique_Id" Video_Id
			,0 IsUpcomingLiveStream
			,'media' MediaType	  
			,b."Business_Name" BusinessName
			,b."Business_Image" BusinessImage
			,b."Background_Image" BackgroundImage
			,b."Shortname" MerchantShortName
			,m."Desktop_Image_Url" DesktopImageUrl
			,m."Mobile_Image_Url" MobileImageUrl
			,m."Tablet_Image_Url" TabletImageUrl	
			,m."Channel_Name" EventName
			,m."Channel_Desc" EventDesc
	from "MediaByUserAndChannel" m
	join "Live_Stream_Info" ls on m."Media_Unique_Id" = ls."Unique_Id"
	join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id" 
	join "Business" b on ci."Business_Id" = b."Business_Id"
	join "AspNetUsers" u on m."User_Id" = u."Id"
	join userChannel uc on b."Business_Id" = uc.BusinessId
	left join "Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id"
	where b."Is_Active" = 'Y'
	and (ul."Is_Private_Event" = false or ul."Is_Private_Event" is null)
	and (ul."Upcoming_Live_Stream_Id" is null or (ul."Upcoming_Live_Stream_Id" is not null and (ul."End_Date_Time" is null or ul."End_Date_Time" < NOW())))
	and COALESCE(ul."Is_Active",'Y' )= 'Y' 
	 and m."Is_Active" = true
	 and m."Is_Private_Event" = true
	UNION 
	select  0 IsLive
			,ci."Channel_Id" ChannelId
			,ci."Channel_Name" ChannelName
			,m."Video_Channel_Id" Media_Item_Id
			,m."User_Id"
			,m."Video_Url" Media_Url 
			,m."Video_Thumbnail_Url" Media_thumbnailUrl
			,m."Video_Gif_Url" Media_thumbnailGifUrl
			,m."Created_Date"
			,u."ImageUrl" User_Profile_Image
			,u."ThumbnailImageUrl" User_Thumbnail_Image
			,m."Description" ChannelDesc
			,m."Video_Unique_Id" Video_Id
			,0 IsUpcomingLiveStream
			,'media' MediaType
			,b."Business_Name" BusinessName
			,b."Business_Image" BusinessImage
			,b."Background_Image" BackgroundImage
			,b."Shortname" MerchantShortName
			,m."Desktop_Thumbnail_Url" DesktopImageUrl
			,m."Mobile_Thumbnail_Url" MobileImageUrl
			,m."Tablet_Thumbnail_Url" TabletImageUrl	
			,m."Title" EventName
			,m."Description" EventDesc
	from "Video_Channel" m
	join "Channel_Info" ci on m."Business_Id"= ci."Business_Id"
	join "Business" b on ci."Business_Id" = b."Business_Id"
	join "AspNetUsers" u on m."User_Id" = u."Id"
	join userChannel uc on b."Business_Id" = uc.BusinessId
	where b."Is_Active" = 'Y'
	and m."Is_Active" = true
	) s
order by "CreatedDate" desc;
RETURN NEXT refcursor2;

DROP TABLE IF EXISTS discountOffer;
CREATE TEMP TABLE discountOffer AS
select d.*
      ,ROW_NUMBER() over(partition by d."Product_Id" order by d."Created_Date" desc) rn
from public."Discount_Offer" d
join businessList bl on d."Business_Id" = bl."Business_Id"
where DATE(NOW()) between DATE("Valid_Start_Date") and date("Valid_End_Date");

-- with discountOffer as (
-- select do.*
-- 	  ,ROW_NUMBER() over(partition by do.product_id order by do.created_date desc) rn
-- from Discount_Offer do
-- join #businessList bl on do.Business_Id = bl.Business_Id
-- where GETDATE()  between valid_start_date and valid_end_date
-- )

OPEN refcursor3 FOR
select BusinessId
	  ,ProductDescription
	  ,ProductName
	  ,ProductId
	  ,ProductVideoId
	  ,ProductImage
	  ,"Price"
	  ,DesktopImageUrl
	  ,MobileImageUrl
	  ,TabletImageUrl
	  ,Review
	  ,COALESCE(DiscountedPrice,"Price") DiscountedPrice
	  ,IsDiscountAvailable
	  ,COALESCE(DiscountPercentage,0) DiscountPercentage
from (
select p."Business_Id" BusinessId
	    ,p."Product_Description" ProductDescription
	    ,p."Product_Name" ProductName 
	    ,p."Product_Id" ProductId
	    ,p."productvid" ProductVideoId
	    ,pi."Image_Url" ProductImage
		,pvl."Price"
	     ,ROW_NUMBER() over(partition by p."Product_Id" order by pi."Created_Date" desc) rn
		,pi."Desktop_Image_Url" DesktopImageUrl
		,pi."Mobile_Image_Url" MobileImageUrl
		,pi."Tablet_Image_Url" TabletImageUrl
		,pr.Review
		,cast (pvl."Price"  - (pvl."Price"  * d."Discount_Percentage" / 100) as decimal(10,2)) DiscountedPrice
		,CASE WHEN d."Discount_Percentage" > 0 THEN 1 ELSE 0 END IsDiscountAvailable
		,d."Discount_Percentage" DiscountPercentage
from public."Product" p 
join "Business_Product" bp on p."Product_Id" = bp."Product_id"
join businessList b on bp."Business_Id" = b."Business_Id"
join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join (select 0 BusinessId
				, pr."Product_Id" ProductId
	  			,CAST(ROUND((SUM(pr."Review_Rating") / COUNT(pr."Product_Review_Id")),2) as numeric(10,2)) Review
			from "Product" p
		   join "Business_Product" bp on p."Product_Id" = bp."Product_id"
			join "Product_Review" pr on p."Product_Id" = pr."Product_Id"
			join businessList b on bp."Business_Id" = b."Business_Id"
			where (p."Status" is null or p."Status" = 'active')
			group by pr."Product_Id"
			UNION
			select pr."Business_Id" BusinessId
				  ,0 ProductId
				  ,CAST(ROUND((SUM(pr."Review_Rating") / COUNT(pr."Business_Review_Id")),2) as numeric(10,2)) Review
			from businessList p
			join "Business_Review" pr on p."Business_Id" = pr."Business_Id"
			group by pr."Business_Id") pr on ( p."Product_Id" = pr.ProductId or bp."Business_Id" = pr.BusinessId) 
			left join discountOffer d on b."Business_Id" = d."Business_Id" 
									and (d."Product_Id" is null or d."Product_Id" = p."Product_Id") 
									and (d.rn is null or d.rn = 1)
			where (p."Status" is null or p."Status" = 'active')
			and pvl."Status" = 'active') p
where rn = 1;
RETURN NEXT refcursor3;

OPEN refcursor4 FOR
select COALESCE(sum(ls."Like_Count"),0)  :: bigint LikeCount
from "Live_Stream_Info" ls
join "Upcoming_Live_Stream" ul on ls."Unique_Id" = ul."Media_Unique_Id"
join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
join "Business" b on ci."Business_Id" = b."Business_Id"
where ul."Is_Private_Event" = false
and Lower(b."Shortname") = Lower(shortName)
group by b."Business_Id";
RETURN NEXT refcursor4;

OPEN refcursor5 FOR
select (select Count(*) :: integer TotalPost 
		from "MediaByUserAndChannel" m
		left join "Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id" 
		left join "Live_Stream_Info" ls on ul."Media_Unique_Id" = ls."Unique_Id"
		left join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
		left join "Business" b on ci."Business_Id" = b."Business_Id"
		where Lower(b."Shortname") = Lower(shortName)
		and COALESCE(ul."Is_Private_Event",false) = false and COALESCE(ul."Is_Active",'Y' )= 'Y') 
		+
		(select Count(*) TotalPost
		from "Video_Channel" vc 
		join "Business" b on vc."Business_Id" = b."Business_Id"
		where Lower(b."Shortname") = Lower(shortName)
		and vc."Is_Active" = true) TotalPost;
RETURN NEXT refcursor5;

END;
$BODY$;

