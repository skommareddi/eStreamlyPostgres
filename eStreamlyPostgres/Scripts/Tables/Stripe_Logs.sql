
CREATE TABLE IF NOT EXISTS public."Stripe_Logs"
(
    "Stripe_Log_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Request_Detail" text COLLATE pg_catalog."default" NOT NULL,
    "Response_Detail" text COLLATE pg_catalog."default",
    "Stripe_Request_Detail" text COLLATE pg_catalog."default",
    "Stripe_Response_Detail" text COLLATE pg_catalog."default",
    "Live_Unique_Id" character varying COLLATE pg_catalog."default",
    "Product_Id" bigint,
    "User_Id" character varying COLLATE pg_catalog."default",
    "Api_Url" character varying COLLATE pg_catalog."default",
    "Api_Method" character varying COLLATE pg_catalog."default",
    "Payment_Method" character varying COLLATE pg_catalog."default",
    "Status" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_stripe_logs PRIMARY KEY ("Stripe_Log_Id"),
    CONSTRAINT stripe_logs_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Stripe_Logs"
    ON public."Stripe_Logs" USING btree
    ("Stripe_Log_Id" ASC NULLS LAST)
    TABLESPACE pg_default;