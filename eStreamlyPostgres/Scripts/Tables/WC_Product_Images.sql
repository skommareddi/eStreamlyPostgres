﻿

CREATE TABLE IF NOT EXISTS public."WC_Product_Images"
(
    "Product_Image_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "WC_Product_Id" bigint NOT NULL,
    "WC_Product_Image_Id" bigint NOT NULL,
    "Position" integer,
    "Image_Name" character varying COLLATE pg_catalog."default",
    "Image_Src" character varying COLLATE pg_catalog."default",
    "Image_Alt" character varying COLLATE pg_catalog."default",
    "Image_Created_Date" timestamp with time zone,
    "Image_Updated_Date" timestamp with time zone,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_wc_product_images PRIMARY KEY ("Product_Image_Id"),
    CONSTRAINT wcproductimages_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."WC_Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_WC_Product_Images"
    ON public."WC_Product_Images" USING btree
    ("Product_Image_Id" ASC NULLS LAST)
    TABLESPACE pg_default;