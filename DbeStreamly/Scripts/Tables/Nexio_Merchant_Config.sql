
CREATE TABLE IF NOT EXISTS public."Nexio_Merchant_Config"
(
    "Nexio_Merchant_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Merchant_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Nexio_UserName" character varying COLLATE pg_catalog."default" NOT NULL,
    "Nexio_Password" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_nexio_merchant_config PRIMARY KEY ("Nexio_Merchant_Config_Id"),
    CONSTRAINT fk_nexio_merchant_config_business FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Nexio_Merchant_Config"
    ON public."Nexio_Merchant_Config" USING btree
    ("Nexio_Merchant_Config_Id" ASC NULLS LAST)
    TABLESPACE pg_default;