
CREATE TABLE IF NOT EXISTS public."Product_Shipping_Detail"
(
    "Product_Shipping_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint,
    "Shipping_Detail" character varying COLLATE pg_catalog."default" NOT NULL,
    "Return_Detail" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Shipping_Amount" numeric NOT NULL,
    "Shipping_Amount_Weight" numeric NOT NULL,
    "Max_Order_Amount" numeric NOT NULL,
    "Business_Id" bigint NOT NULL DEFAULT 0,
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_product_shipping_detail PRIMARY KEY ("Product_Shipping_Id"),
    CONSTRAINT productshippingdetail_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Product_Shipping_Detail"
    ON public."Product_Shipping_Detail" USING btree
    ("Product_Shipping_Id" ASC NULLS LAST)
    TABLESPACE pg_default;