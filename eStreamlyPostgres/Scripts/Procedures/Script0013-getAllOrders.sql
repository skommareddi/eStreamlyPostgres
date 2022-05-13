CREATE PROCEDURE [dbo].[getAllOrders]

AS
BEGIN
  select * from Customer_Order co inner join dbo.AspNetUsers u on u.Id = co.UserId
inner join dbo.Product p on p.Product_Id= co.Product_Id
order by  co.Created_Date desc
END