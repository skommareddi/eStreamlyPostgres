
CREATE TABLE IF NOT EXISTS public."Business_Banking_Info"
(
    "Business_Bank_Info_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Account_Number" character varying COLLATE pg_catalog."default",
    "Routing_Number" character varying COLLATE pg_catalog."default",
    "Bank_Name" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_businessbankinginfo PRIMARY KEY ("Business_Bank_Info_Id"),
    CONSTRAINT businessbankinginfo_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_BusinessBankingInfo"
    ON public."Business_Banking_Info" USING btree
    ("Business_Bank_Info_Id" ASC NULLS LAST)
    TABLESPACE pg_default;