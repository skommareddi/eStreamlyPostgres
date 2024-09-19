-- Table: public.Shopify_Checkout_Shipping_Rates

-- DROP TABLE IF EXISTS public."Shopify_Checkout_Shipping_Rates";

CREATE TABLE IF NOT EXISTS public."Shopify_Checkout_Shipping_Rates"
(
    "Shopify_Checkout_Shipping_Rates_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Shopify_Checkout_Id" bigint NOT NULL,
    "Shipping_Rate_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Shipping_Rate_Price" numeric NOT NULL,
    "Shipping_Rate_Title" character varying COLLATE pg_catalog."default" NOT NULL,
    "Shipping_Rate_Handle" character varying COLLATE pg_catalog."default" NOT NULL,
    "Checkout_Total_Tax" numeric NOT NULL,
    "Checkout_Total_Price" numeric NOT NULL,
    "Checkout_Subtotal_Price" numeric NOT NULL,
    "Shipping_Rate_Details" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "Shopify_Checkout_Shipping_Rates_pkey" PRIMARY KEY ("Shopify_Checkout_Shipping_Rates_Id"),
    CONSTRAINT shopify_checkout_fk_shopify_checkout_id FOREIGN KEY ("Shopify_Checkout_Id")
        REFERENCES public."Shopify_Checkout" ("Shopify_Checkout_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)