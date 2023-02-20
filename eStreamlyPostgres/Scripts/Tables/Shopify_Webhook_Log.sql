-- Table: public.Shopify_Webhook_Log

-- DROP TABLE IF EXISTS public."Shopify_Webhook_Log";

CREATE TABLE IF NOT EXISTS public."Shopify_Webhook_Log"
(
    "Shopify_Webhook_Log_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Webhook_Topic" character varying COLLATE pg_catalog."default" NOT NULL,
    "Shopify_Store_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Shopify_Webhook_Id" character varying COLLATE pg_catalog."default",
    "Request_Payload" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default",
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "Shopify_Webhook_Log_pkey" PRIMARY KEY ("Shopify_Webhook_Log_Id")
);