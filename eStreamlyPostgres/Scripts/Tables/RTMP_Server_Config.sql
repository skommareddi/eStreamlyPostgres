-- Table: public.RTMP_Server_Config

-- DROP TABLE IF EXISTS public."RTMP_Server_Config";

CREATE TABLE IF NOT EXISTS public."RTMP_Server_Config"
(
    "RTMP_Server_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "RTMP_Server_Url" character varying COLLATE pg_catalog."default" NOT NULL,
    "Room_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "App_Id" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Stream_Key" character varying COLLATE pg_catalog."default",
    "Stream_Url" character varying COLLATE pg_catalog."default",
    "Is_App_Live" character varying COLLATE pg_catalog."default",
    "Tiktok_Stream_Url" character varying COLLATE pg_catalog."default",
    "Titktok_Stream_Key" character varying COLLATE pg_catalog."default",
    "Is_Tiktok_Active" boolean,
    "Restream_Stream_Url" character varying COLLATE pg_catalog."default",
    "Restream_Stream_Key" character varying COLLATE pg_catalog."default",
    "Is_Restream_Active" boolean,
    CONSTRAINT pk_rtmp_server_config PRIMARY KEY ("RTMP_Server_Config_Id"),
    CONSTRAINT fk_rtmp_server_config_business FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Index: PK_RTMP_Server_Config

-- DROP INDEX IF EXISTS public."PK_RTMP_Server_Config";

CREATE INDEX IF NOT EXISTS "PK_RTMP_Server_Config"
    ON public."RTMP_Server_Config" USING btree
    ("RTMP_Server_Config_Id" ASC NULLS LAST)
    TABLESPACE pg_default;