
CREATE TABLE IF NOT EXISTS public."Media_Convert_Job"
(
    "Media_Convert_Job_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Job_Id" character varying COLLATE pg_catalog."default",
    "Asset_Id" character varying COLLATE pg_catalog."default",
    "Video_Url" character varying COLLATE pg_catalog."default",
    "Video_Gif_Url" character varying COLLATE pg_catalog."default",
    "Desktop_Thumbnail_Url" character varying COLLATE pg_catalog."default",
    "Mobile_Thumbnail_Url" character varying COLLATE pg_catalog."default",
    "Tablet_Thumbnail_Url" character varying COLLATE pg_catalog."default",
    "M3U8_Url" character varying COLLATE pg_catalog."default",
    "Job_Status" character varying COLLATE pg_catalog."default",
    "Job_Started_Time" timestamp with time zone,
    "Job_Completed_Time" timestamp with time zone,
    "DurationInSeconds" integer,
    "Created_Date" timestamp with time zone NOT NULL DEFAULT now(),
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_media_convert_job PRIMARY KEY ("Media_Convert_Job_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Media_Convert_Job"
    ON public."Media_Convert_Job" USING btree
    ("Media_Convert_Job_Id" ASC NULLS LAST)
    TABLESPACE pg_default;