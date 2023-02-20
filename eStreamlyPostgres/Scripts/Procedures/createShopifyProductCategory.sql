
CREATE OR REPLACE FUNCTION public."createShopifyProductCategory"(
	"businessId" bigint,
	ref refcursor)
    RETURNS refcursor
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
Begin

OPEN REF FOR 
select distinct Product_Type into TEMP TABLE producttype
from Shopify_Product 
where Product_Type <> '' and Business_Id = businessId
and Status = 'active';
RETURN REF;

End
$BODY$;

