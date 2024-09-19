CREATE TABLE public."Api_Logs" (
    "Api_Log_Id" bigint NOT NULL,
    "Request_Detail" text NOT NULL,
    "Response_Detail" text,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying,
    "Record_Version" numeric DEFAULT 1 NOT NULL
);


ALTER TABLE public."Api_Logs" ALTER COLUMN "Api_Log_Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Api_Logs_Api_Log_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
