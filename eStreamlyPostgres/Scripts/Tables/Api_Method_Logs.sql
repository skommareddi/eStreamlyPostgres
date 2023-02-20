
CREATE TABLE IF NOT EXISTS public."Api_Method_Logs"
(
    "Api_Method_Logs_Id" uuid NOT NULL DEFAULT uuid_generate_v4(),
    "Method_Name" character varying COLLATE pg_catalog."default",
    "HttpMethod" character varying COLLATE pg_catalog."default",
    "Request_Detail" character varying COLLATE pg_catalog."default",
    "Response_Detail" character varying COLLATE pg_catalog."default",
    "Service_Name" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "Api_Method_Logs_pkey" PRIMARY KEY ("Api_Method_Logs_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;