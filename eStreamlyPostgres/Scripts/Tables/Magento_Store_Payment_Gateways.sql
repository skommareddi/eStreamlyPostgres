-- Table: public.Magento_Store_Payment_Gateways

-- DROP TABLE IF EXISTS public."Magento_Store_Payment_Gateways";

CREATE TABLE IF NOT EXISTS public."Magento_Store_Payment_Gateways"
(
    "Magento_Store_Payment_Gateway_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Magento_Store_Id" bigint NOT NULL,
    "Payment_Code" character varying COLLATE pg_catalog."default" NOT NULL,
    "Payment_Title" character varying COLLATE pg_catalog."default",
    "Rest_Key_Id" character varying COLLATE pg_catalog."default",
    "Rest_Key_Value" character varying COLLATE pg_catalog."default",
    "Sop_Profile_Id" character varying COLLATE pg_catalog."default",
    "Sop_Access_Key" character varying COLLATE pg_catalog."default",
    "Sop_Secret_Key" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Active" boolean DEFAULT true,
    "Merchant_Id" character varying COLLATE pg_catalog."default",
    "ClientId" character varying COLLATE pg_catalog."default",
    "SandboxClientId" character varying COLLATE pg_catalog."default",
    "ApiUser" character varying COLLATE pg_catalog."default",
    "ApiPassword" character varying COLLATE pg_catalog."default",
    "ApiSignature" character varying COLLATE pg_catalog."default",
    "PaymentAction" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Magento_Store_Payment_Gateways_pkey" PRIMARY KEY ("Magento_Store_Payment_Gateway_Id"),
    CONSTRAINT "Magento_Store_Payment_Gateways_fk_Magento_Store" FOREIGN KEY ("Magento_Store_Id")
        REFERENCES public."Magento_Store_Detail" ("Magento_Store_Detail_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)