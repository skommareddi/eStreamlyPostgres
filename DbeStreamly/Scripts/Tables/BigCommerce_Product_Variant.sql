CREATE TABLE IF NOT EXISTS public."BigCommerce_Product_Variant"
(
    "Product_Variant_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "BigCommerce_Product_Id" bigint NOT NULL,
    "BigCommerce_Product_Variant_Id" bigint NOT NULL,
    "Cost_Price" numeric,
    "Price" numeric,
    "Sale_Price" numeric,
    "Retail_Price" numeric,
    "Product_Variant_JSON" character varying COLLATE pg_catalog."default" NOT NULL,
    "Product_Variant_Option_JSON" character varying COLLATE pg_catalog."default",
    "Product_Id" bigint NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Calculated_Price" numeric,
    CONSTRAINT "pk_BigCommerce_Product_Variant" PRIMARY KEY ("Product_Variant_Id"),
    CONSTRAINT bigcommerceproductvariant_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."BigCommerce_Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);