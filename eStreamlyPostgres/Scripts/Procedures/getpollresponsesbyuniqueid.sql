
CREATE OR REPLACE FUNCTION public.getpollresponsesbyuniqueid(
	uniqueid character varying,
	ref1 refcursor)
    RETURNS SETOF refcursor 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$

BEGIN

OPEN ref1 FOR SELECT pr.*, pi.*
  FROM "Poll_Responses" pr
  inner join "Poll_Info" pi on pi."Poll_Info_Id" = pr."Poll_Info_Id"
  where pi."Unique_Id" = UniqueId;

RETURN NEXT ref1;
END
$BODY$;
