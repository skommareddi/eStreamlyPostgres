-- Table: public.Product_Variant_List

-- DROP TABLE IF EXISTS public."Product_Variant_List";

CREATE TABLE IF NOT EXISTS public."Product_Variant_List"
(
    "Product_Variant_List_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Product_Measurement_Id" bigint NOT NULL,
    "Price" numeric NOT NULL,
    "Weight" numeric,
    "Product_Variant1_Id" bigint NOT NULL,
    "Variant_Value1" character varying COLLATE pg_catalog."default" NOT NULL,
    "Product_Variant2_Id" bigint,
    "Variant_Value2" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Shopify_Product_Variants_Id" bigint,
    "Title" character varying COLLATE pg_catalog."default",
    "Product_Variant3_Id" bigint,
    "Variant_Value3" character varying COLLATE pg_catalog."default",
    "WC_Product_Variants_Id" bigint,
    "Position" integer,
    "Status" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "BigCommerce_Product_Variant_Id" bigint,
    CONSTRAINT pk_product_variant_list PRIMARY KEY ("Product_Variant_List_Id"),
    CONSTRAINT productvariantlist_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT productvariantlist_fk_productmeasurementid FOREIGN KEY ("Product_Measurement_Id")
        REFERENCES public."Product_Measurement" ("Product_Measurement_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT productvariantlist_fk_productvariant1id FOREIGN KEY ("Product_Variant1_Id")
        REFERENCES public."Product_Variant" ("Product_Variant_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Index: PK_Product_Variant_List

-- DROP INDEX IF EXISTS public."PK_Product_Variant_List";

CREATE INDEX IF NOT EXISTS "PK_Product_Variant_List"
    ON public."Product_Variant_List" USING btree
    ("Product_Variant_List_Id" ASC NULLS LAST)
    TABLESPACE pg_default;