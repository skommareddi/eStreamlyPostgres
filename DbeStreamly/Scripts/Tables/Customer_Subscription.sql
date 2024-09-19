
CREATE TABLE IF NOT EXISTS public."Customer_Subscription"
(
    "Customer_Subscription_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Customer_Id" bigint NOT NULL,
    "Subscription_Id" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Subscription_Status" character varying COLLATE pg_catalog."default",
    "Product_Id" bigint,
    "Stripe_Price_Id" character varying COLLATE pg_catalog."default",
    "Customer_Billing_Address_Id" bigint,
    "Customer_Shipping_Address_Id" bigint,
    "Product_Variant_List_Id" bigint,
    "Live_Unique_Id" character varying COLLATE pg_catalog."default",
    "Free_Shipping_Promotion_Amount" numeric,
    "Shipping_Amount" numeric,
    "Tax_Amount" numeric,
    "Subtotal" numeric,
    "Discount_Amount" numeric,
    "Other_Discount" numeric,
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_customer_subscription PRIMARY KEY ("Customer_Subscription_Id"),
    CONSTRAINT customersubscription_fk_customerid FOREIGN KEY ("Customer_Id")
        REFERENCES public."Customer" ("Customer_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Customer_Subscription"
    ON public."Customer_Subscription" USING btree
    ("Customer_Subscription_Id" ASC NULLS LAST)
    TABLESPACE pg_default;