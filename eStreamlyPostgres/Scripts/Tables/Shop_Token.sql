
CREATE TABLE IF NOT EXISTS public."Shop_Token"
(
    "Shop_Token_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Shop_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Token" character varying COLLATE pg_catalog."default",
    "Installed_Date" timestamp with time zone,
    "Uninstalled_Date" timestamp with time zone,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_shop_token PRIMARY KEY ("Shop_Token_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Shop_Token"
    ON public."Shop_Token" USING btree
    ("Shop_Token_Id" ASC NULLS LAST)
    TABLESPACE pg_default;