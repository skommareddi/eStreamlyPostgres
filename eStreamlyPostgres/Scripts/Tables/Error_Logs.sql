
CREATE TABLE IF NOT EXISTS public."Error_Logs"
(
    "Error_Log_Id" uuid NOT NULL DEFAULT uuid_generate_v4(),
    "Entered_Date" timestamp with time zone DEFAULT now(),
    "Log_Level" character varying COLLATE pg_catalog."default",
    "Log_Logger" character varying COLLATE pg_catalog."default",
    "Log_Message" character varying COLLATE pg_catalog."default",
    "Log_Exception" character varying COLLATE pg_catalog."default",
    "Log_Stack_trace" character varying COLLATE pg_catalog."default",
    "Log_Created_By" character varying COLLATE pg_catalog."default",
    "Log_Created_Date" timestamp with time zone NOT NULL,
    "Error_Page" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL DEFAULT now(),
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_errorlogs PRIMARY KEY ("Error_Log_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_ErrorLogs"
    ON public."Error_Logs" USING btree
    ("Error_Log_Id" ASC NULLS LAST)
    TABLESPACE pg_default;