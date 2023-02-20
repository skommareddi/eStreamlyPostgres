
CREATE OR REPLACE FUNCTION public.uuid_generate_v5(
	namespace uuid,
	name text)
    RETURNS uuid
    LANGUAGE 'c'
    COST 1
    IMMUTABLE STRICT PARALLEL SAFE 
AS '$libdir/uuid-ossp', 'uuid_generate_v5'
;


