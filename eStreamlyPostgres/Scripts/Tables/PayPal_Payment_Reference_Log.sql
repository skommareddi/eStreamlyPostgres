
CREATE TABLE IF NOT EXISTS public."PayPal_Payment_Reference_Log"
(
    "Payment_Ref_Id" bigint NOT NULL,
    "Payment_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "pk_PayPal_Payment_Reference_Log" PRIMARY KEY ("Payment_Ref_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Paypal_log"
    ON public."PayPal_Payment_Reference_Log" USING btree
    ("Payment_Ref_Id" ASC NULLS LAST)
    TABLESPACE pg_default;