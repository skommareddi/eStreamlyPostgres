
CREATE TABLE IF NOT EXISTS public."PayPal_Order_Detail"
(
    "PayPal_Order_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Quantity" bigint NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Product_Variant_List_Id" bigint NOT NULL,
    "PayPal_Order_Id" bigint NOT NULL,
    "Price" numeric,
    "Actual_Price" numeric,
    "Subtotal" numeric,
    CONSTRAINT pk_paypal_order_detail PRIMARY KEY ("PayPal_Order_Detail_Id"),
    CONSTRAINT paypalorderdetail_fk_paypalorder FOREIGN KEY ("PayPal_Order_Id")
        REFERENCES public."PayPal_Order" ("PayPal_Order_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT paypalorderdetail_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT paypalorderdetail_fk_productvariantlistid FOREIGN KEY ("Product_Variant_List_Id")
        REFERENCES public."Product_Variant_List" ("Product_Variant_List_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
