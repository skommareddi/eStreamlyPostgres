
CREATE TABLE IF NOT EXISTS public."Customer"
(
    "Customer_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Stripe_Customer_Id" character varying COLLATE pg_catalog."default",
    "Stripe_Card_Id" character varying COLLATE pg_catalog."default",
    "Customer_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Customer_Email" character varying COLLATE pg_catalog."default" NOT NULL,
    "Card_Name" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Square_Customer_Id" character varying COLLATE pg_catalog."default",
    "Paypal_Customer_Id" character varying COLLATE pg_catalog."default",
    "UserId" character varying COLLATE pg_catalog."default",
    "First_Name" character varying COLLATE pg_catalog."default",
    "Last_Name" character varying COLLATE pg_catalog."default",
    "EStreamly_Customer_Id" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "BC_Customer_Id" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_customer PRIMARY KEY ("Customer_Id"),
    CONSTRAINT customer_fk_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Customer"
    ON public."Customer" USING btree
    ("Customer_Id" ASC NULLS LAST)
    TABLESPACE pg_default;