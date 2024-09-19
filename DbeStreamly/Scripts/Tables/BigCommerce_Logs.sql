
CREATE TABLE IF NOT EXISTS public."BigCommerce_Logs"
(
    "BigCommerce_Log_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Request_Detail" text COLLATE pg_catalog."default" NOT NULL,
    "Response_Detail" text COLLATE pg_catalog."default",
    "BigCommerce_Request_Detail" text COLLATE pg_catalog."default",
    "BigCommerce_Response_Detail" text COLLATE pg_catalog."default",
    "Live_Unique_Id" character varying COLLATE pg_catalog."default",
    "Product_Id_List" character varying COLLATE pg_catalog."default",
    "User_Id" character varying COLLATE pg_catalog."default",
    "Api_Url" character varying COLLATE pg_catalog."default",
    "Api_Method" character varying COLLATE pg_catalog."default",
    "Payment_Method" character varying COLLATE pg_catalog."default",
    "Status" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_bigcommerce_logs PRIMARY KEY ("BigCommerce_Log_Id")
);

CREATE INDEX IF NOT EXISTS "PK_BigCommerce_Logs"
    ON public."BigCommerce_Logs" USING btree
    ("BigCommerce_Log_Id" ASC NULLS LAST)
    TABLESPACE pg_default;