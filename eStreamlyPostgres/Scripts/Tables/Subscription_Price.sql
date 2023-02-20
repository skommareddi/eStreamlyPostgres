
CREATE TABLE IF NOT EXISTS public."Subscription_Price"
(
    "Subscription_Price_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Stripe_Price_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Price" numeric NOT NULL,
    "Interval" character varying COLLATE pg_catalog."default" NOT NULL,
    "Interval_Count" integer NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Subscription_Name" character varying COLLATE pg_catalog."default",
    "product_variant_list_Id" bigint NOT NULL DEFAULT 0,
    "Is_Active" boolean,
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_subscription_price PRIMARY KEY ("Subscription_Price_Id"),
    CONSTRAINT subscriptionprice_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Subscription_Price"
    ON public."Subscription_Price" USING btree
    ("Subscription_Price_Id" ASC NULLS LAST)
    TABLESPACE pg_default;