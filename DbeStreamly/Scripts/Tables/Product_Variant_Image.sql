

CREATE TABLE IF NOT EXISTS public."Product_Variant_Image"
(
    "Product_Variant_Image_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Product_Variant_List_Id" bigint NOT NULL,
    "Image_Url" character varying COLLATE pg_catalog."default" NOT NULL,
    "Position" bigint NOT NULL,
    "BigCommerce_Product_Image_Id" bigint,
    "Shopify_product_image_Id" bigint,
    "WC_product_image_Id" bigint,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_product_variant_image PRIMARY KEY ("Product_Variant_Image_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."Product_Variant_Image"
    OWNER to iresponsive;