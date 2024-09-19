
CREATE TABLE IF NOT EXISTS public."Customer_Address"
(
    "Customer_Address_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Customer_Id" bigint NOT NULL,
    "Name" character varying COLLATE pg_catalog."default",
    "Phone" character varying COLLATE pg_catalog."default",
    "Address_Type_Id" integer NOT NULL,
    "Line1" character varying COLLATE pg_catalog."default",
    "Line2" character varying COLLATE pg_catalog."default",
    "City" character varying COLLATE pg_catalog."default",
    "Country" character varying COLLATE pg_catalog."default",
    "PostalCode" character varying COLLATE pg_catalog."default",
    "State" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "First_Name" character varying COLLATE pg_catalog."default",
    "Last_Name" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_customer_address PRIMARY KEY ("Customer_Address_Id"),
    CONSTRAINT customer_address_fk_address_type_id FOREIGN KEY ("Address_Type_Id")
        REFERENCES public."Address_Type" ("Address_Type_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT customer_address_fk_customer_id FOREIGN KEY ("Customer_Id")
        REFERENCES public."Customer" ("Customer_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Customer_Address"
    ON public."Customer_Address" USING btree
    ("Customer_Address_Id" ASC NULLS LAST)
    TABLESPACE pg_default;