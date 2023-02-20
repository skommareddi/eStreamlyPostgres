
CREATE OR REPLACE FUNCTION public.getvideointeractivity(
	videouniqueidparam character varying)
    RETURNS TABLE(channelid character varying, information character varying, polltime numeric, polltype integer, quesdesc character varying, quesoptions character varying, shoutoutvalue character varying, videochannelid bigint, videointeractivityid bigint, videouniqueid character varying, productdescription character varying, productname character varying, productid bigint, imageurl character varying, price numeric, discount_offer_id bigint, business_id bigint, product_id bigint, discount_name character varying, discount_percentage numeric, discount_rate numeric, valid_start_date timestamp with time zone, valid_end_date timestamp with time zone, created_date timestamp with time zone, created_by character varying, modified_date timestamp with time zone, modified_by character varying, upcoming_unique_id character varying, record_version numeric, rn bigint, revenue numeric) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	DECLARE 
     BEGIN
CREATE TEMP TABLE interactivity AS    
with discount as (select dof.*
							,ROW_NUMBER() over(partition by dof."Product_Id" order by dof."Created_Date" desc) rn
					from "Discount_Offer" dof
					--join #customerorder co on do.Product_Id = co.Product_Id
					where NOW()  >= "Valid_Start_Date"
					or( "Valid_Start_Date" <= NOW() and "Valid_End_Date" >= NOW())
					)

	select vi."Channel_Id" ChannelId
			,vi."Information" 
			,vi."Poll_Time" PollTime
			,vi."Poll_Type" PollType
			,vi."Ques_Desc" QuesDesc 
			,vi."Ques_Options" QuesOptions
			,vi."ShoutOutValue"
			,vi."Video_Channel_Id" VideoChannelId 
			,vi."Video_Interactivity_Id" VideoInteractivityId
			,vi."Video_Unique_Id" VideoUniqueId
			,p."Product_Description" ProductDescription
			,p."Product_Name" ProductName
			,p."Product_Id" ProductId
			,pi."Image_Url" ImageUrl
			,pvl."Price"
			,d.*
	from "Video_Interactivity" vi 
	left join "Product" p on vi."Product_Id" = p."Product_Id"
	left join "Product_Variant_List" pvl on p."Product_Id" = pvl."Product_Id" and pvl."Position" = 1
	left join "Product_Image" pi on p."Product_Id" = pi."Product_Id" and pi."Position" = 1
	left join discount d on p."Product_Id" = d."Product_Id"
				and (d."rn" is null or d."rn" = 1)
	where vi."Video_Unique_Id" = videoUniqueIdParam;
	
	RETURN QUERY
	
select i.*
			,cast(r.Revenue / 100 as decimal(10,2)) Revenue
	from interactivity i
	join (select  i.VideoUniqueId
				 ,SUM("Amount") Revenue
		  from "Customer_Order" co
		  join interactivity i on co."Live_Unique_Id" = i.VideoUniqueId 
						and i."Product_Id" = co."Product_Id"
		  group by i.VideoUniqueId
			) r on i.VideoUniqueId = r.VideoUniqueId;

DROP TABLE interactivity;
END; 
$BODY$;

