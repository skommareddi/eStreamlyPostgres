-- Table: public.Product

-- DROP TABLE IF EXISTS public."Product";

CREATE TABLE IF NOT EXISTS public."Product"
(
    "Product_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Product_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Product_Description" character varying COLLATE pg_catalog."default",
    productvid character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Product_Category_Id" bigint,
    "Stripe_Price_Id" character varying COLLATE pg_catalog."default",
    "Status" character varying COLLATE pg_catalog."default",
    "Shopify_Product_Id" bigint,
    "WC_Product_Id" bigint,
    "Note" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Tipser_Product_Id" character varying COLLATE pg_catalog."default",
    "Price" numeric,
    "SKU" character varying COLLATE pg_catalog."default",
    "BigCommerce_Product_Id" bigint,
    CONSTRAINT pk_product PRIMARY KEY ("Product_Id"),
    CONSTRAINT product_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT product_fk_productcategoryid FOREIGN KEY ("Product_Category_Id")
        REFERENCES public."Product_Category" ("Product_Category_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Index: Business_Status

-- DROP INDEX IF EXISTS public."Business_Status";

CREATE INDEX IF NOT EXISTS "Business_Status"
    ON public."Product" USING btree
    ("Business_Id" ASC NULLS LAST, "Status" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: PK_Product

-- DROP INDEX IF EXISTS public."PK_Product";

CREATE INDEX IF NOT EXISTS "PK_Product"
    ON public."Product" USING btree
    ("Product_Id" ASC NULLS LAST)
    TABLESPACE pg_default;