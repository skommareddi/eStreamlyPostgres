
CREATE TABLE IF NOT EXISTS public."Nexio_Payment"
(
    "Nexio_Payment_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Event_Type" character varying COLLATE pg_catalog."default",
    "Data" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_nexio_payment PRIMARY KEY ("Nexio_Payment_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Nexio_Payment"
    ON public."Nexio_Payment" USING btree
    ("Nexio_Payment_Id" ASC NULLS LAST)
    TABLESPACE pg_default;