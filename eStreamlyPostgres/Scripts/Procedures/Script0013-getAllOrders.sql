CREATE OR REPLACE FUNCTION getAllOrders(ref refcursor) 
RETURNS refcursor AS $$
BEGIN
	OPEN ref FOR select * 
				 from public."Customer_Order" co
				 join public."AspNetUsers" u on u."Id" = co."UserId"
				 join public."Product" p on p."Product_Id"= co."Product_Id"
				 order by  co."Created_Date" desc;
	RETURN ref;
END;
$$ LANGUAGE plpgsql;
