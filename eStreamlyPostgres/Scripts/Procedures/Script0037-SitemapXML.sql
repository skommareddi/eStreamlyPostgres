CREATE OR REPLACE FUNCTION SitemapXML(ref1 refcursor,
ref2 refcursor) 
RETURNS SETOF refcursor AS $$
BEGIN

OPEN ref1 FOR  select xml= '<url><loc>https://estreamly.com/product/'+convert(varchar, "Product_Id") + '</loc></url>' 
from "Product"
where "Status" ='active';

RETURN NEXT  ref1;

OPEN ref2 FOR select xml= '<url><loc>https://estreamly.com/'+convert(varchar, "Shortname") + '</loc></url>' 
from "Business"
where "Is_Active" = 'Y';

RETURN NEXT  ref2;
END
$$ LANGUAGE plpgsql;