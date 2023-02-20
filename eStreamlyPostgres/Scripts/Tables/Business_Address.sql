
CREATE TABLE IF NOT EXISTS public."Business_Address"
(
    "Business_Address_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Street" character varying COLLATE pg_catalog."default",
    "City" character varying COLLATE pg_catalog."default",
    "Country" character varying COLLATE pg_catalog."default",
    "PostalCode" character varying COLLATE pg_catalog."default",
    "State" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_business_address PRIMARY KEY ("Business_Address_Id"),
    CONSTRAINT businessaddress_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Business_Address"
    ON public."Business_Address" USING btree
    ("Business_Address_Id" ASC NULLS LAST)
    TABLESPACE pg_default;