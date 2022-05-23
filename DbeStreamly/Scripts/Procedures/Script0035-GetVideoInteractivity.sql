CREATE PROCEDURE [dbo].[GetVideoInteractivity]
(
    -- Add the parameters for the stored procedure here
@videoUniqueId varchar(250)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
   
	;with discount as (select do.*
							,ROW_NUMBER() over(partition by do.product_id order by do.created_date desc) rn
					from Discount_Offer do
					--join #customerorder co on do.Product_Id = co.Product_Id
					where GETDATE()  >= Valid_Start_Date
					or( Valid_Start_Date <= GETDATE() and Valid_End_Date >= GETDATE())
					)

	select vi.Channel_Id ChannelId
			,vi.Information 
			,vi.Poll_Time PollTime
			,vi.Poll_Type PollType
			,vi.Ques_Desc QuesDesc 
			,vi.Ques_Options QuesOptions
			,vi.ShoutOutValue
			,vi.Video_Channel_Id VideoChannelId 
			,vi.Video_Interactivity_Id VideoInteractivityId
			,vi.Video_Unique_Id VideoUniqueId
			,p.Product_Description ProductDescription
			,p.Product_Name ProductName
			,p.Product_Id ProductId
			,pi.Image_Url ImageUrl
			,pvl.Price
			,d.*
	INTO #interactivity
	from Video_Interactivity vi 
	left join Product p on vi.Product_Id = p.Product_Id
	left join Product_Variant_List pvl on p.Product_Id = pvl.Product_Id and pvl.Position = 1
	left join Product_Image pi on p.Product_Id = pi.Product_Id and pi.Position = 1
	left join discount d on p.Product_Id = d.Product_Id
				and (d.rn is null or d.rn = 1)
	where vi.Video_Unique_Id = @videoUniqueId

	select i.*
			,cast(r.Revenue / 100 as decimal(10,2)) Revenue
	from #interactivity i
	join (select  i.VideoUniqueId
				 ,SUM(Amount) Revenue
		  from Customer_Order co
		  join #interactivity i on co.Live_Unique_Id = i.VideoUniqueId 
						and i.Product_Id = co.Product_Id
		  group by i.VideoUniqueId
			) r on i.VideoUniqueId = r.VideoUniqueId


	drop table #interactivity
END