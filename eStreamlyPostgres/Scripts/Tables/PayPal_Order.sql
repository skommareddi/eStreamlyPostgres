
CREATE TABLE IF NOT EXISTS public."PayPal_Order"
(
    "PayPal_Order_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "UserId" character varying COLLATE pg_catalog."default",
    "EStreamly_Customer_Id" character varying COLLATE pg_catalog."default",
    "Customer_Id" bigint,
    "Customer_Billing_Address_Id" bigint,
    "Customer_Shipping_Address_Id" bigint,
    "Paypal_Customer_Id" character varying COLLATE pg_catalog."default",
    "Paypal_Payment_Id" character varying COLLATE pg_catalog."default",
    "Live_Unique_Id" character varying COLLATE pg_catalog."default",
    "Subtotal" numeric,
    "Shipping_Amount" numeric,
    "Tax_Amount" numeric,
    "Free_Shipping_Promotion_Amount" numeric,
    "Discount_Amount" numeric,
    "Other_Discount" numeric,
    "TotalAmount" numeric,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_From_Cart" boolean DEFAULT false,
    "Is_Payment_From_Live" boolean DEFAULT false,
    CONSTRAINT pk_paypal_order PRIMARY KEY ("PayPal_Order_Id"),
    CONSTRAINT paypalorder_fk_customerid FOREIGN KEY ("Customer_Id")
        REFERENCES public."Customer" ("Customer_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_PayPal_Order"
    ON public."PayPal_Order" USING btree
    ("PayPal_Order_Id" ASC NULLS LAST)
    TABLESPACE pg_default;