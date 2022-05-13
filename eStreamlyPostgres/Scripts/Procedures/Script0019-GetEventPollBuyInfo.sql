CREATE PROCEDURE [dbo].[GetEventPollBuyInfo] -- GetEventPollBuyInfo 'gbCUqt2Se5L'
(
  @uniqueId varchar(50)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
DECLARE @startDate datetime,@endDate datetime;

select @startDate = Start_Date_Time,@endDate = End_Date_Time 
from Upcoming_Live_Stream
where Media_Unique_Id = @uniqueId

select co.Product_Id
		,SUM(co.Quantity) soldcount
INTO #customerorder
from Customer_Order co 
left join Live_Stream_Info ls on co.Live_Unique_Id = ls.Unique_Id --or co.Live_Unique_Id = ls.Upcoming_Unique_Id
where @uniqueId = ls.Unique_Id or @uniqueId= ls.Upcoming_Unique_Id
group by co.Live_Unique_Id,co.Product_Id;

select do.*
	  ,ROW_NUMBER() over(partition by do.product_id order by do.created_date desc) rn
into #discount
from Discount_Offer do
--join #customerorder co on do.Product_Id = co.Product_Id
where 
--GETDATE()  >= Valid_Start_Date
--or( Valid_Start_Date <= GETDATE() and Valid_End_Date >= GETDATE())
--and 
--GETDATE() between Valid_Start_Date and Valid_End_Date
Valid_End_Date >= @startDate 
and Valid_Start_Date <= @endDate

select *
	  ,ROW_NUMBER() over(partition by dc.product_id order by dc.created_date desc) rn
INTO #coupon
from Discount_Coupon dc 
where Valid_Start_Date >= @startDate
and Valid_End_Date <= @endDate

;with Poll as (
	select poll.*
			,ROW_NUMBER() OVER (PARTITION BY productid ORDER BY poll_info_id DESC) rno
		from (select distinct c.*
							,1 IsPollPosted
							,pi.Poll_Info_Id Poll_Info_Id
							, 0 Upcoming_Poll_Info_Id
			from Poll_Info pi 
			Cross apply
				OPENJSON(pi.poll_info_detail)
				WITH (
					ChannelId varchar(150) '$.ChannelId',
					PollUniqueId NVARCHAR(50) '$.PollUniqueId',
					ProductId decimal(10) '$.ProductId',	
					Name NVARCHAR(50) '$.Item.Name',
					ItemUrl NVARCHAR(1000) '$.Item.ItemUrl',
					Description NVARCHAR(1000) '$.Item.Description',
					Price decimal(10,2) '$.Item.Price'
				) c
	where pi.Unique_Id = @uniqueId
		and pi.Poll_Type = 2
	UNION
	select  distinct c.*
					,pi.Is_Poll_Posted IsPollPosted
					,0 Poll_Info_Id
					,pi.Upcoming_Poll_Info_Id
	from Upcoming_Poll_Info pi 
	Cross apply
		OPENJSON(pi.poll_info_detail)
		WITH (
			ChannelId varchar(150) '$.ChannelId',
			PollUniqueId NVARCHAR(50) '$.UpcomingUniqueId',
			ProductId decimal(10) '$.ProductId',	
			Name NVARCHAR(50) '$.Item.Name',
			ItemUrl NVARCHAR(1000) '$.Item.ItemUrl',
			Description NVARCHAR(1000) '$.Item.Description',
			Price decimal(10,2) '$.Item.Price'
		) c
	where pi.Upcoming_Unique_Id = @uniqueId
		and pi.Poll_Type = 2 
		and pi.Is_Poll_Posted = 0) poll
	)
	select Poll.*
			,ISNULL(co.soldcount,0) SoldCount
			,d.*
			,c.Discount_Coupon_Id DiscountCouponId
			,c.Coupon_Code CouponCode
			,c.Discount_Percentage DiscountPercentage
			,c.Product_Id CouponProduct
			,c.Valid_Start_Date ValidStartDate 
			,c.Valid_End_Date ValidEndDate 
	from poll 
	left join #customerorder co on poll.ProductId = co.Product_Id
	left join #discount d on poll.ProductId = d.Product_Id
				and (d.rn is null or d.rn = 1)
	left join #coupon c on Poll.ProductId = c.Product_Id
				and (c.rn is null or c.rn = 1)
	where Poll.rno = 1
	and Productid > 0

	drop table #customerorder
	drop table #discount
END