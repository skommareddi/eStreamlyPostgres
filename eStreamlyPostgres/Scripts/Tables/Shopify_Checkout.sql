-- Table: public.Shopify_Checkout

-- DROP TABLE IF EXISTS public."Shopify_Checkout";

CREATE TABLE IF NOT EXISTS public."Shopify_Checkout"
(
    "Shopify_Checkout_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Shopify_Shop_Id" bigint NOT NULL,
    "Checkout_Token" character varying COLLATE pg_catalog."default" NOT NULL,
    "Checkout_Details" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Checkout_Url" character varying COLLATE pg_catalog."default",
    "Is_Moved_To_Abandoned_Checkout" boolean,
    CONSTRAINT "Shopify_Checkout_pkey" PRIMARY KEY ("Shopify_Checkout_Id"),
    CONSTRAINT shopify_checkout_fk_business_shopify_shop FOREIGN KEY ("Business_Shopify_Shop_Id")
        REFERENCES public."Business_Shopify_Shop" ("Business_Shopify_Shop_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)