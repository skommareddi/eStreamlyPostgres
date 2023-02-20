
CREATE TABLE IF NOT EXISTS public."Amazon_Transcribe_Job"
(
    "Amazon_Transcribe_Job_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Job_Id" character varying COLLATE pg_catalog."default",
    "Asset_Id" character varying COLLATE pg_catalog."default",
    "Video_Url" character varying COLLATE pg_catalog."default",
    "SRT_File_Url" character varying COLLATE pg_catalog."default",
    "VTT_File_Url" character varying COLLATE pg_catalog."default",
    "Text_File_Url" character varying COLLATE pg_catalog."default",
    "Job_Status" character varying COLLATE pg_catalog."default",
    "Job_Started_Time" timestamp with time zone,
    "Job_Completed_Time" timestamp with time zone,
    "Created_Date" timestamp with time zone NOT NULL DEFAULT now(),
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_amazon_transcribe_job PRIMARY KEY ("Amazon_Transcribe_Job_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Amazon_Transcribe_Job"
    ON public."Amazon_Transcribe_Job" USING btree
    ("Amazon_Transcribe_Job_Id" ASC NULLS LAST)
    TABLESPACE pg_default;