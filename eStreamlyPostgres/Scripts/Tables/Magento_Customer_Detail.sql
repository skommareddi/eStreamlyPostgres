-- Table: public.Magento_Customer_Detail

-- DROP TABLE IF EXISTS public."Magento_Customer_Detail";

CREATE TABLE IF NOT EXISTS public."Magento_Customer_Detail"
(
    "Magento_Customer_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "First_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Last_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Email" character varying COLLATE pg_catalog."default" NOT NULL,
    "Magento_Customer_Id" character varying COLLATE pg_catalog."default",
    "Is_Active" boolean NOT NULL DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "UserId" character varying COLLATE pg_catalog."default",
    "Password" character varying COLLATE pg_catalog."default",
    "Business_Id" bigint,
    CONSTRAINT "Magento_Customer_Detail_pkey" PRIMARY KEY ("Magento_Customer_Detail_Id")
)