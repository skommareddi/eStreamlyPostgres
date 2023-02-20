-- Table: public.Shopify_Product_Update_Job

-- DROP TABLE IF EXISTS public."Shopify_Product_Update_Job";

CREATE TABLE IF NOT EXISTS public."Shopify_Product_Update_Job"
(
    "Shopify_Product_Update_Job_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Job_Input_Detail" character varying COLLATE pg_catalog."default" NOT NULL,
    "Job_Output_Detail" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "Shopify_Product_Update_Job_pkey" PRIMARY KEY ("Shopify_Product_Update_Job_Id")
);