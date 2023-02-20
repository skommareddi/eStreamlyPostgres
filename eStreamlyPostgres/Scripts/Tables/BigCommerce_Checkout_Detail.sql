
CREATE TABLE IF NOT EXISTS public."BigCommerce_Checkout_Detail"
(
    "BigCommerce_Checkout_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Checkout_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Consignment_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Customer_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Customer_Billing_Address_Id" bigint,
    "Customer_Shipping_Address_Id" bigint,
    "BigCommerce_Customer_Id" bigint,
    "Live_Unique_Id" character varying COLLATE pg_catalog."default",
    "BigCommerce_Checkout_Response" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_From_Cart" boolean DEFAULT false,
    "Is_Payment_From_Live" boolean DEFAULT false,
    "Request_JSON" character varying COLLATE pg_catalog."default",
    "Status" character varying COLLATE pg_catalog."default",
    CONSTRAINT "BigCommerce_Checkout_Detail_pkey" PRIMARY KEY ("BigCommerce_Checkout_Detail_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;