﻿
CREATE OR REPLACE FUNCTION public.pg_stat_statements_reset(
	)
    RETURNS void
    LANGUAGE 'c'
    COST 1
    VOLATILE PARALLEL SAFE 
AS '$libdir/pg_stat_statements', 'pg_stat_statements_reset'
;


