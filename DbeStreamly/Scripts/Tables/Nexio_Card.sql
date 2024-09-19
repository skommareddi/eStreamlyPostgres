
CREATE TABLE IF NOT EXISTS public."Nexio_Card"
(
    "Nexio_Card_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Merchant_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Card_Holder_Name" character varying COLLATE pg_catalog."default",
    "Expiration_Month" character varying COLLATE pg_catalog."default",
    "Expiration_Year" character varying COLLATE pg_catalog."default",
    "First_Six" character varying COLLATE pg_catalog."default",
    "Last_Four" character varying COLLATE pg_catalog."default",
    "Token" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_nexio_card PRIMARY KEY ("Nexio_Card_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Nexio_Card"
    ON public."Nexio_Card" USING btree
    ("Nexio_Card_Id" ASC NULLS LAST)
    TABLESPACE pg_default;