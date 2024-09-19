CREATE TABLE IF NOT EXISTS public."BigCommerce_Checkout_Items"
(
    "BigCommerce_Checkout_Items_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "BigCommerce_Checkout_Id" bigint NOT NULL,
    "Product_Id" bigint NOT NULL,
    "Product_Variant_List_Id" bigint NOT NULL,
    "Quantity" bigint NOT NULL,
    "Price" numeric,
    "Actual_Price" numeric,
    "Subtotal" numeric,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "BigCommerce_Checkout_Items_pkey" PRIMARY KEY ("BigCommerce_Checkout_Items_Id"),
    CONSTRAINT "bigCommercecheckoutitems_fk_bigcommercecheckoutdetailid" FOREIGN KEY ("BigCommerce_Checkout_Id")
        REFERENCES public."BigCommerce_Checkout_Detail" ("BigCommerce_Checkout_Detail_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);