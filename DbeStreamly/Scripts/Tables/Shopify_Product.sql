
CREATE TABLE IF NOT EXISTS public."Shopify_Product"
(
    "Product_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Shopify_Product_Id" bigint NOT NULL,
    "Business_Id" bigint NOT NULL,
    "Title" character varying COLLATE pg_catalog."default" NOT NULL,
    "Description" character varying COLLATE pg_catalog."default",
    "Vendor" character varying COLLATE pg_catalog."default",
    "Product_Type" character varying COLLATE pg_catalog."default",
    "Status" character varying COLLATE pg_catalog."default",
    "Product_Created_Date" timestamp with time zone,
    "Product_Updated_Date" timestamp with time zone,
    "Product_Published_Date" timestamp with time zone,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_shopify_product PRIMARY KEY ("Product_Id"),
    CONSTRAINT shopifyproduct_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Shopify_Product"
    ON public."Shopify_Product" USING btree
    ("Product_Id" ASC NULLS LAST)
    TABLESPACE pg_default;