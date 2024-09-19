-- Table: public.Magento_Store_Detail

-- DROP TABLE IF EXISTS public."Magento_Store_Detail";

CREATE TABLE IF NOT EXISTS public."Magento_Store_Detail"
(
    "Magento_Store_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Store_Code" character varying COLLATE pg_catalog."default",
    "Store_Name" character varying COLLATE pg_catalog."default",
    "Store_Status" character varying COLLATE pg_catalog."default",
    "Store_Id" character varying COLLATE pg_catalog."default",
    "Store_Url" character varying COLLATE pg_catalog."default",
    "First_Name" character varying COLLATE pg_catalog."default",
    "Last_Name" character varying COLLATE pg_catalog."default",
    "Email" character varying COLLATE pg_catalog."default",
    "Phone_Number" character varying COLLATE pg_catalog."default",
    "Currency" character varying COLLATE pg_catalog."default",
    "Base_Currency" character varying COLLATE pg_catalog."default",
    "Country" character varying COLLATE pg_catalog."default",
    "Website_Id" character varying COLLATE pg_catalog."default",
    "Website_Code" character varying COLLATE pg_catalog."default",
    "Website_Name" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Active" boolean NOT NULL DEFAULT true,
    "Business_Id" bigint,
    "Short_Name" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Magento_Store_Detail_pkey" PRIMARY KEY ("Magento_Store_Detail_Id")
)