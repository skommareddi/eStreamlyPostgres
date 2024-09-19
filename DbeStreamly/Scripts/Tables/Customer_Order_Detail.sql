-- Table: public.Customer_Order_Detail

-- DROP TABLE IF EXISTS public."Customer_Order_Detail";

CREATE TABLE IF NOT EXISTS public."Customer_Order_Detail"
(
    "Customer_Order_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Quantity" bigint NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Product_Variant_List_Id" bigint NOT NULL,
    "Customer_Order_Id" bigint NOT NULL,
    "Price" numeric,
    "Actual_Price" numeric,
    "Subtotal" numeric,
    CONSTRAINT pk_customer_order_detail PRIMARY KEY ("Customer_Order_Detail_Id"),
    CONSTRAINT customerorderdetail_fk_customerorder FOREIGN KEY ("Customer_Order_Id")
        REFERENCES public."Customer_Order" ("Customer_Order_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT customerorderdetail_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT customerorderdetail_fk_productvariantlistid FOREIGN KEY ("Product_Variant_List_Id")
        REFERENCES public."Product_Variant_List" ("Product_Variant_List_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);