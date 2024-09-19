
CREATE TABLE IF NOT EXISTS public.schemaversions
(
    schemaversionsid integer NOT NULL DEFAULT nextval('schemaversions_schemaversionsid_seq'::regclass),
    scriptname character varying(255) COLLATE pg_catalog."default" NOT NULL,
    applied timestamp without time zone NOT NULL,
    CONSTRAINT "PK_schemaversions_Id" PRIMARY KEY (schemaversionsid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;