CREATE TABLE IF NOT EXISTS public."BigCommerce_Product_Image"
(
    "Product_Image_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "BigCommerce_Product_Image_Id" bigint NOT NULL,
    "Is_Thumbnail" boolean,
    "Sort_Order" integer,
    "Description" character varying COLLATE pg_catalog."default",
    "Image_File" character varying COLLATE pg_catalog."default",
    "Url_Zoom" character varying COLLATE pg_catalog."default",
    "Url_Standard" character varying COLLATE pg_catalog."default",
    "Url_Thumbnail" character varying COLLATE pg_catalog."default",
    "Url_Tiny" character varying COLLATE pg_catalog."default",
    "Date_Modified" timestamp with time zone,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_bigcommerce_product_image PRIMARY KEY ("Product_Image_Id"),
    CONSTRAINT bigcommerceproductimage_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."BigCommerce_Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);