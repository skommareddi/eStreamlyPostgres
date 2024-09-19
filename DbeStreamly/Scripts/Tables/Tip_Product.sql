-- Table: public.Tip_Product

-- DROP TABLE IF EXISTS public."Tip_Product";

CREATE TABLE IF NOT EXISTS public."Tip_Product"
(
    "Tip_Product_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Product_Id" bigint NOT NULL,
    "Is_Active" boolean NOT NULL DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "Tip_Product_pkey" PRIMARY KEY ("Tip_Product_Id"),
    CONSTRAINT tip_product_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT tip_product_fk_product FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);