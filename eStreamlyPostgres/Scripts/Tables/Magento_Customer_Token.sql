-- Table: public.Magento_Customer_Token

-- DROP TABLE IF EXISTS public."Magento_Customer_Token";

CREATE TABLE IF NOT EXISTS public."Magento_Customer_Token"
(
    "Magento_Customer_Token_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "UserName" character varying COLLATE pg_catalog."default" NOT NULL,
    "Token" character varying COLLATE pg_catalog."default" NOT NULL,
    "Expiry_Date" timestamp with time zone NOT NULL,
    "Is_Active" boolean NOT NULL DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Magento_Customer_Detail_Id" bigint,
    CONSTRAINT "Magento_Customer_Token_pkey" PRIMARY KEY ("Magento_Customer_Token_Id")
)