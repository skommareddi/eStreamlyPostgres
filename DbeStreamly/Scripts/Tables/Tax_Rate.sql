
CREATE TABLE IF NOT EXISTS public."Tax_Rate"
(
    "Tax_Rate_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Country_Code" character varying COLLATE pg_catalog."default" NOT NULL,
    "Country" character varying COLLATE pg_catalog."default" NOT NULL,
    "Region_Code" character varying COLLATE pg_catalog."default",
    "Region" character varying COLLATE pg_catalog."default",
    "Minimun_Rate_Lable" character varying COLLATE pg_catalog."default" NOT NULL,
    "Minimum_Rate" numeric NOT NULL,
    "Average_Rate_Lable" character varying COLLATE pg_catalog."default" NOT NULL,
    "Average_Rate" numeric NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_tax_rate PRIMARY KEY ("Tax_Rate_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Tax_Rate"
    ON public."Tax_Rate" USING btree
    ("Tax_Rate_Id" ASC NULLS LAST)
    TABLESPACE pg_default;