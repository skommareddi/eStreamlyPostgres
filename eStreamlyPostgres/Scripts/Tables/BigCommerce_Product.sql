CREATE TABLE IF NOT EXISTS public."BigCommerce_Product"
(
    "Product_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "BigCommerce_Product_Id" bigint NOT NULL,
    "Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Type" character varying COLLATE pg_catalog."default" NOT NULL,
    "SKU" character varying COLLATE pg_catalog."default",
    "Description" character varying COLLATE pg_catalog."default",
    "Weight" numeric,
    "Price" numeric NOT NULL,
    "Cost_Price" numeric,
    "Retail_Price" numeric,
    "Sale_Price" numeric,
    "Map_Price" numeric,
    "Product_JSON" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Business_Id" bigint,
    CONSTRAINT "pk_BigCommerce_Product" PRIMARY KEY ("Product_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;