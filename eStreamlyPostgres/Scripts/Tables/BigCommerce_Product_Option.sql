CREATE TABLE IF NOT EXISTS public."BigCommerce_Product_Option"
(
    "Product_Option_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "BigCommerce_Product_Option_Id" bigint NOT NULL,
    "Display_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Type" character varying COLLATE pg_catalog."default" NOT NULL,
    "Sort_Order" integer,
    "Product_Option_JSON" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "pk_BigCommerce_Product_Option" PRIMARY KEY ("Product_Option_Id"),
    CONSTRAINT bigcommerceproductoption_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."BigCommerce_Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);