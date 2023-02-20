
CREATE TABLE IF NOT EXISTS public."Customer_Order"
(
    "Customer_Order_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Stripe_Customer_Id" character varying COLLATE pg_catalog."default",
    "Product_Id" bigint,
    "Stripe_Charge_Id" character varying COLLATE pg_catalog."default",
    "Stripe_Payment_Intent_Id" character varying COLLATE pg_catalog."default",
    "Order_Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Order_Placed" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'N'::bpchar,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Order_Id" character varying COLLATE pg_catalog."default",
    "Quantity" integer,
    "Amount" numeric,
    "UserId" character varying COLLATE pg_catalog."default",
    "Customer_Id" bigint,
    "Paypal_Customer_Id" character varying COLLATE pg_catalog."default",
    "Paypal_Payment_Id" character varying COLLATE pg_catalog."default",
    "Customer_Billing_Address_Id" bigint,
    "Customer_Shipping_Address_Id" bigint,
    "Shipping_Amount" numeric,
    "Tax_Amount" numeric,
    "Live_Unique_Id" character varying COLLATE pg_catalog."default",
    "Free_Shipping_Promotion_Amount" numeric,
    "Subtotal" numeric,
    "Product_Variant_List_Id" bigint,
    "Square_Customer_Id" character varying COLLATE pg_catalog."default",
    "Square_Card_Payment_Id" character varying COLLATE pg_catalog."default",
    "Order_Status" character varying COLLATE pg_catalog."default" DEFAULT 'Pending'::character varying,
    "Discount_Amount" numeric,
    "Other_Discount" numeric,
    "Payment_Method" character varying COLLATE pg_catalog."default",
    "Nexio_Payment_Id" character varying COLLATE pg_catalog."default",
    "EStreamly_Customer_Id" character varying COLLATE pg_catalog."default",
    "Is_Payment_Confirmed" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_From_Cart" boolean DEFAULT false,
    "Is_Payment_From_Live" boolean DEFAULT false,
    "BC_Payment_Transaction_Id" character varying COLLATE pg_catalog."default",
    "BC_Order_Id" bigint,
    CONSTRAINT pk_customer_order PRIMARY KEY ("Customer_Order_Id"),
    CONSTRAINT customerorder_fk_customerid FOREIGN KEY ("Customer_Id")
        REFERENCES public."Customer" ("Customer_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Customer_Order"
    ON public."Customer_Order" USING btree
    ("Customer_Order_Id" ASC NULLS LAST)
    TABLESPACE pg_default;