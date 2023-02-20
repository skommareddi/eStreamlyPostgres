
CREATE TABLE IF NOT EXISTS public."Api_Logs"
(
    "Api_Log_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Request_Detail" text COLLATE pg_catalog."default" NOT NULL,
    "Response_Detail" text COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_api_logs PRIMARY KEY ("Api_Log_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Api_Logs"
    ON public."Api_Logs" USING btree
    ("Api_Log_Id" ASC NULLS LAST)
    TABLESPACE pg_default;