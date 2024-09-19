
CREATE TABLE IF NOT EXISTS public."Square_Config"
(
    "Square_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "App_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Access_Token" character varying COLLATE pg_catalog."default" NOT NULL,
    "Location_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_square_config PRIMARY KEY ("Square_Config_Id"),
    CONSTRAINT squareconfig_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Square_Config"
    ON public."Square_Config" USING btree
    ("Square_Config_Id" ASC NULLS LAST)
    TABLESPACE pg_default;