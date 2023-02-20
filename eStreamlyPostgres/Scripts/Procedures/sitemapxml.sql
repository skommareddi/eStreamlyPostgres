
CREATE OR REPLACE FUNCTION public.sitemapxml(
	ref1 refcursor,
	ref2 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
BEGIN

OPEN ref1 FOR  
select '<url><loc>https://estreamly.com/product/'|| ("Product_Id" :: varchar) || '</loc></url>'  as xml
from "Product"
where "Status" ='active';

RETURN NEXT  ref1;

OPEN ref2 FOR 
select  '<url><loc>https://estreamly.com/'||"Shortname" || '</loc></url>' as xml
from "Business"
where "Is_Active" = 'Y';

RETURN NEXT  ref2;
END
$BODY$;

