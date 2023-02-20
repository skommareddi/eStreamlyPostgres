CREATE TABLE IF NOT EXISTS public."Address_Type"
(
    "Address_Type_Id" integer NOT NULL,
    "Address_Type_Description" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_address_type PRIMARY KEY ("Address_Type_Id")
);

CREATE INDEX IF NOT EXISTS "PK_Address_Type"
    ON public."Address_Type" USING btree
    ("Address_Type_Id" ASC NULLS LAST)
    TABLESPACE pg_default;