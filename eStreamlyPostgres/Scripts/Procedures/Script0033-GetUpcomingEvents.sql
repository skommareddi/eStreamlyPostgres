CREATE OR REPLACE FUNCTION GetUpcomingEvents(liveUniqueId varchar,
											 refcursor1 refcursor,
											 refcursor2 refcursor,
											 refcursor3 refcursor,
											 refcursor4 refcursor,
											 refcursor5 refcursor,
											 refcursor6 refcursor,
											 refcursor7 refcursor,
											 refcursor8 refcursor)
 RETURNS SETOF refcursor
AS $$
BEGIN

DROP TABLE IF EXISTS upcomingevent;
CREATE TEMP TABLE upcomingevent AS
select ul."Upcoming_Live_Stream_Id"
	    ,ul."Name"
	    ,ul."Description" Description
	    ,ul."Channel_Id" ChannelId
	    ,ul."Media_Unique_Id"
	    ,ul."Start_Date_Time" StartDateTime
	    ,ul."End_Date_Time" EndDateTime
	    ,ul."User_Id"
	    ,ul."Event_Image" EventImage
	    ,ul."Desktop_Image_Url" DesktopImageUrl
	    ,ul."Mobile_Image_Url" MobileImageUrl
	    ,ul."Tablet_Image_Url" TabletImageUrl
	    ,u."ImageUrl" User_Profile_Image
	    ,u."ThumbnailImageUrl" User_Thumbnail_Image
		,b."Business_Name" BusinessName 
		,b."Business_Image" BusinessImage
		,b."Background_Image" BackgroundImage
		,ci."Channel_Name" ChannelName
		,b."Shortname" MerchantShortName
		,ul."Name" EventName
		,ul."Description" EventDesc
		,b."Business_Id"
--INTO #upcomingevent
from "Upcoming_Live_Stream" ul
join "Channel_Info" ci on ul."Channel_Id" = ci."Channel_Id"
join "Business" b on ci."Business_Id" = b."Business_Id"
left join "AspNetUsers" u on ul."User_Id" = u."Id"
where ul."Media_Unique_Id" = liveUniqueId;

DROP TABLE IF EXISTS userChannel;
CREATE TEMP TABLE userChannel AS
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
	    ROW_NUMBER() OVER (PARTITION BY ci."Channel_Id" ORDER BY ci."Channel_Id" ) AS rn,
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

OPEN refcursor1 FOR
select distinct e."Upcoming_Live_Stream_Id"
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
		,uc."Business_Name" 
		,uc."Business_Image"
		,uc."Background_Image"
		,uc."Channel_Name"
		,uc."Shortname" MerchantShortName
		,e."Name" EventName
		,e."Description" EventDesc
		,e."Event_Video_Url" EventVideoUrl
		,e."Event_Video_Gif_Url" EventVideoGifUrl
from "Upcoming_Live_Stream" e
join userChannel uc on e."Channel_Id" = uc."Channel_Id"
left join "AspNetUsers" u on e."User_Id" = u."Id"
left join "Live_Stream_Info" li on e."Media_Unique_Id" = COALESCE(li."Upcoming_Unique_Id",li."Unique_Id")
where e."Media_Unique_Id" != liveUniqueId
and "Start_Date_Time" >= NOW()
and e."Is_Private_Event" = false
and (li."Live_Stream_Info_Id" is null or li."Live_Stream_Info_Id" = 0)
order by e."Start_Date_Time";
RETURN NEXT refcursor1;

OPEN refcursor2 FOR
select  0 IsLive
	    ,ci."Channel_Id" ChannelId
	    ,ci."Channel_Name" ChannelName
	    ,m."Media_Item_Id"
	    ,m."User_Id" 
	    ,m."Media_Url" Media_Url 
	    ,m."Media_thumbnail_Url"  Media_thumbnailUrl
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
join userChannel uc on b."Business_Id" = uc."Business_Id"
left join "Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id"
where b."Is_Active" = 'Y'
and (ul."Is_Private_Event" = false or ul."Is_Private_Event" is null)
and (ul."Upcoming_Live_Stream_Id" is null or (ul."Upcoming_Live_Stream_Id" is not null and (ul."End_Date_Time" is null or ul."End_Date_Time" < NOW())))
and ul."Is_Active" = 'Y'
order by m."CreatedDate" desc;
RETURN NEXT refcursor2;

DROP TABLE IF EXISTS discountOffer;
CREATE TEMP TABLE discountOffer AS
select d.*
      ,ROW_NUMBER() over(partition by d."Product_Id" order by d."Created_Date" desc) rn
from public."Discount_Offer" d
join upcomingevent bl on d."Business_Id" = bl."Business_Id"
where DATE(NOW()) between DATE("Valid_Start_Date") and date("Valid_End_Date");

OPEN refcursor3 FOR
select BusinessId
	  ,ProductDescription
	  ,ProductName
	  ,ProductId
	  ,ProductVideoId
	  ,ProductImage
	  ,DesktopImageUrl
	  ,MobileImageUrl
	  ,TabletImageUrl
	  ,"Price"
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
		,pi."Desktop_Image_Url" DesktopImageUrl
		,pi."Mobile_Image_Url" MobileImageUrl
		,pi."Tablet_Image_Url" TabletImageUrl
		,pvl."Price"
	    ,ROW_NUMBER() OVER (PARTITION BY p."Product_Id" ORDER BY pi."Created_Date" ) AS rn
		,cast (pvl."Price"  - (pvl."Price"  * d."Discount_Percentage" / 100) as decimal(10,2)) DiscountedPrice
		,CASE WHEN d."Discount_Percentage" > 0 THEN 1 ELSE 0 END IsDiscountAvailable
		,d."Discount_Percentage" DiscountPercentage
from "Product" p 
join upcomingevent b on p."Business_Id" = b."Business_Id"
join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id"
left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
left join discountOffer d on b."Business_Id" = d."Business_Id" and (d."Product_Id" is null or d."Product_Id" = p."Product_Id")
where p."Status" = 'active' and (d.rn = 1 or rn is null)) p
where rn = 1 ;
RETURN NEXT refcursor3;

OPEN refcursor4 FOR
select * 
from upcomingevent;
RETURN NEXT refcursor4;

OPEN refcursor5 FOR
select f."Business_Id" BusinessId
	  ,f."Influencer_Id" InfluencerId
	  ,f."UserId" UserId
	  ,us."FullName" UserName
	  ,us."ImageUrl" User_Profile_Image
	  ,us."ThumbnailImageUrl" User_Thumbnail_Image
from "Follower" f
join upcomingevent u on f."Business_Id" = u."Business_Id"
join "AspNetUsers" us on f."UserId" = us."Id";
RETURN NEXT refcursor5;

OPEN refcursor6 FOR
select  * 
from userChannel;
RETURN NEXT refcursor6;

OPEN refcursor7 FOR
select COALESCE(sum(ls."Like_Count"),0) LikeCount
from "Live_Stream_Info" ls
join "Upcoming_Live_Stream" ul on ls."Unique_Id" = ul."Media_Unique_Id"
join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
join "Business" b on ci."Business_Id" = b."Business_Id"
join userChannel uc on b."Business_Id" = uc."Business_Id"
where ul."Is_Private_Event" = false
group by b."Business_Id";
RETURN NEXT refcursor7;

OPEN refcursor8 FOR
select (select Count(*) TotalPost 
		from "MediaByUserAndChannel" m
		join "Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id" 
		join "Live_Stream_Info" ls on ul."Media_Unique_Id" = ls."Unique_Id"
		join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id"
		join "Business" b on ci."Business_Id" = b."Business_Id"
		join userChannel uc on b."Business_Id" = uc."Business_Id"
		where ul."Is_Private_Event" = false and ul."Is_Active" = 'Y') 
		+
		(select Count(*) TotalPost
		from "Video_Channel" vc 
		join "Business" b on vc."Business_Id" = b."Business_Id"
		 join userChannel uc on b."Business_Id" = uc."Business_Id"
		where  vc."Is_Active" = true) TotalPost;
RETURN NEXT refcursor8;

END;
$$ LANGUAGE plpgsql;
