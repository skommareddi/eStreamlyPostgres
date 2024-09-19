CREATE TABLE public."Api_Method_Logs" (
    "Api_Method_Logs_Id" uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    "Method_Name" character varying,
    "HttpMethod" character varying,
    "Request_Detail" character varying,
    "Response_Detail" character varying,
    "Service_Name" character varying,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying,
    "Record_Version" numeric DEFAULT 1 NOT NULL
);
