
CREATE TABLE IF NOT EXISTS public."Business_Payment_Methods"
(
    "Business_Payment_Method_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Payment_Method" character varying COLLATE pg_catalog."default",
    "Sort_Order" bigint,
    "Is_Active" boolean,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Payment_Integration" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_business_payment_methods PRIMARY KEY ("Business_Payment_Method_Id"),
    CONSTRAINT businesspaymentmethod_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Business_Payment_Methods"
    ON public."Business_Payment_Methods" USING btree
    ("Business_Payment_Method_Id" ASC NULLS LAST)
    TABLESPACE pg_default;