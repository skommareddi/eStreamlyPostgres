
CREATE OR REPLACE FUNCTION public.get_video_by_category_for_embed_channel(
	shortname text,
	pid bigint,
	refcursor1 refcursor,
	refcursor2 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
    matched_count INTEGER;
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

DROP TABLE IF EXISTS videoList;
CREATE TEMP TABLE videoList AS
	select * from 
		(select  0 IsLive
				,ci."Channel_Id" ChannelId
				,ci."Channel_Name" ChannelName
				,m."Media_Item_Id"
				,m."User_Id" 
				,m."Media_Url" Media_Url 
				,COALESCE(m."Uploaded_Event_Thumbnail_Image_Url",ul."Event_Image",m."Media_thumbnail_Url") Media_thumbnailUrl
				-- ,COALESCE(m."Uploaded_Event_Thumbnail_Image_Url",m."Media_thumbnail_Url") Media_thumbnailUrl
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
		 		,ul."Keywords" "Keyword"
				,p."Shopify_Product_Id" 
		from "MediaByUserAndChannel" m
		join "Live_Stream_Info" ls on m."Media_Unique_Id" = ls."Unique_Id"
		join "Channel_Info" ci on ls."Channel_Info_Id" = ci."Channel_Info_Id" 
		join "Business" b on ci."Business_Id" = b."Business_Id"
		join "AspNetUsers" u on m."User_Id" = u."Id"
		join userChannel uc on b."Business_Id" = uc.BusinessId
		left join "Upcoming_Live_Stream" ul on m."Media_Unique_Id" = ul."Media_Unique_Id"
		left join "Poll_Info" pi on m."Media_Unique_Id" = pi."Unique_Id" and pi."Poll_Type" = 2
		left join "Product" p on pi."Product_Id" = p."Product_Id"
		where b."Is_Active" = 'Y'
		and (ul."Is_Private_Event" = false or ul."Is_Private_Event" is null)
		and (ul."Upcoming_Live_Stream_Id" is null or (ul."Upcoming_Live_Stream_Id" is not null and (ul."End_Date_Time" is null or ul."End_Date_Time" < NOW())))
		and COALESCE(ul."Is_Active",'Y' )= 'Y' 
		 and m."Is_Active" = true
		 and m."Is_Private_Event" = false
		-- and (pid IS NULL or p."Shopify_Product_Id" = pid)
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
				,'video' MediaType
				,b."Business_Name" BusinessName
				,b."Business_Image" BusinessImage
				,b."Background_Image" BackgroundImage
				,b."Shortname" MerchantShortName
				,m."Desktop_Thumbnail_Url" DesktopImageUrl
				,m."Mobile_Thumbnail_Url" MobileImageUrl
				,m."Tablet_Thumbnail_Url" TabletImageUrl	
				,m."Title" EventName
				,m."Description" EventDesc
		 		,m."Keywords" "Keyword"
				,p."Shopify_Product_Id" 
		from "Video_Channel" m
		join "Channel_Info" ci on m."Business_Id"= ci."Business_Id"
		join "Business" b on ci."Business_Id" = b."Business_Id"
		join "AspNetUsers" u on m."User_Id" = u."Id"
		join userChannel uc on b."Business_Id" = uc.BusinessId
		left join "Video_Interactivity" pi on m."Video_Unique_Id" = pi."Video_Unique_Id"   and pi."Poll_Type" = 2
		left join "Product" p on pi."Product_Id" = p."Product_Id"
		where b."Is_Active" = 'Y'
		and m."Is_Active" = true
	-- and (pid IS NULL or p."Shopify_Product_Id" = pid)
		) s
	order by "CreatedDate" desc;

 SELECT COUNT(*)
    INTO matched_count
    FROM videoList
    WHERE ( "Shopify_Product_Id" = pid);

    -- If there are matching videos, return only those
    IF matched_count > 0 THEN
        OPEN refcursor1 FOR
            SELECT distinct IsLive
				, ChannelId
				, ChannelName
				
				,"User_Id"
				, Media_Url 
				, Media_thumbnailUrl
				, Media_thumbnailGifUrl
				,"CreatedDate"
				, User_Profile_Image
				, User_Thumbnail_Image
				, ChannelDesc
				, Video_Id
				, IsUpcomingLiveStream
				, MediaType
				, BusinessName
				, BusinessImage
				, BackgroundImage
				, MerchantShortName
				, DesktopImageUrl
				, MobileImageUrl
				, TabletImageUrl	
				, EventName
				, EventDesc
		 		,"Keyword"
            FROM videoList
            WHERE "Shopify_Product_Id" = pid;
        RETURN NEXT refcursor1;
    
    -- If no matching videos, return all videos
    ELSE
        OPEN refcursor1 FOR
            SELECT Distinct IsLive
				, ChannelId
				, ChannelName
				,"User_Id"
				, Media_Url 
				, Media_thumbnailUrl
				, Media_thumbnailGifUrl
				,"CreatedDate"
				, User_Profile_Image
				, User_Thumbnail_Image
				, ChannelDesc
				, Video_Id
				, IsUpcomingLiveStream
				, MediaType
				, BusinessName
				, BusinessImage
				, BackgroundImage
				, MerchantShortName
				, DesktopImageUrl
				, MobileImageUrl
				, TabletImageUrl	
				, EventName
				, EventDesc
		 		,"Keyword"
            FROM videoList;
        RETURN NEXT refcursor1;
    END IF;

	
		OPEN refcursor2 FOR
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
	where  e."Is_Private_Event" = false
	and ((li."Live_Stream_Info_Id" is null or li."Live_Stream_Info_Id" = 0)
    AND (CURRENT_TIMESTAMP > e."Start_Date_Time" AND CURRENT_TIMESTAMP < e."End_Date_Time")
) OR e."Start_Date_Time" >= CURRENT_TIMESTAMP
	order by e."Start_Date_Time" asc;
	RETURN NEXT refcursor2;

	END;
	
$BODY$;
