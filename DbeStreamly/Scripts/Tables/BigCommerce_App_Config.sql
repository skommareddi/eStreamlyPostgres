CREATE TABLE IF NOT EXISTS public."BigCommerce_App_Config"
(
    "BigCommerce_App_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Access_Token" character varying COLLATE pg_catalog."default" NOT NULL,
    "Account_UUID" character varying COLLATE pg_catalog."default",
    "Store_Context" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Modified_Date" timestamp with time zone,
    "Business_Id" bigint,
    "Store_Url" character varying COLLATE pg_catalog."default",
    "Is_Uninstalled" boolean,
    "Store_Hash" character varying COLLATE pg_catalog."default",
    CONSTRAINT "BigCommerce_App_Config_pkey" PRIMARY KEY ("BigCommerce_App_Config_Id")
);