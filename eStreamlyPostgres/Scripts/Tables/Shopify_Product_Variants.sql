
CREATE TABLE IF NOT EXISTS public."Shopify_Product_Variants"
(
    "Product_Variant_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Shopify_Product_Id" bigint NOT NULL,
    "Shopify_Product_Variant_Id" bigint NOT NULL,
    "Title" character varying COLLATE pg_catalog."default" NOT NULL,
    "SKU" character varying COLLATE pg_catalog."default",
    "Position" integer,
    "Grams" bigint,
    "Price" numeric,
    "Option1" character varying COLLATE pg_catalog."default",
    "Option2" character varying COLLATE pg_catalog."default",
    "Option3" character varying COLLATE pg_catalog."default",
    "Variant_Created_Date" timestamp with time zone,
    "Variant_Updated_Date" timestamp with time zone,
    "Is_Taxable" boolean,
    "Is_Required_Shipping" boolean,
    "Weight" numeric,
    "Weight_Unit" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_shopify_product_variants PRIMARY KEY ("Product_Variant_Id"),
    CONSTRAINT shopifyproductvariant_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Shopify_Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Shopify_Product_Variants"
    ON public."Shopify_Product_Variants" USING btree
    ("Product_Variant_Id" ASC NULLS LAST)
    TABLESPACE pg_default;