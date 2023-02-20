
CREATE TABLE IF NOT EXISTS public."Product_Image"
(
    "Product_Image_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Image_Url" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Desktop_Image_Url" character varying COLLATE pg_catalog."default",
    "Mobile_Image_Url" character varying COLLATE pg_catalog."default",
    "Tablet_Image_Url" character varying COLLATE pg_catalog."default",
    "Shopify_product_image_Id" bigint,
    "Position" bigint,
    "WC_product_image_Id" bigint,
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "BigCommerce_Product_Image_Id" bigint,
    CONSTRAINT pk_product_image PRIMARY KEY ("Product_Image_Id"),
    CONSTRAINT productimage_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Product_Image"
    ON public."Product_Image" USING btree
    ("Product_Image_Id" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "ProductImage_Position"
    ON public."Product_Image" USING btree
    ("Position" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "Product_Position"
    ON public."Product_Image" USING btree
    ("Product_Id" ASC NULLS LAST, "Position" ASC NULLS LAST, "Image_Url" COLLATE pg_catalog."default" ASC NULLS LAST, "Created_Date" ASC NULLS LAST)
    TABLESPACE pg_default;