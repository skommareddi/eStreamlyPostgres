-- Table: public.Youtube_Stream_Detail

-- DROP TABLE IF EXISTS public."Youtube_Stream_Detail";

CREATE TABLE IF NOT EXISTS public."Youtube_Stream_Detail"
(
    "Youtube_Stream_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Stream_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Broadcast_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Stream_Key" character varying COLLATE pg_catalog."default",
    "Rtmp_Stream_Url" character varying COLLATE pg_catalog."default",
    "Backup_Rtmp_Stream_Url" character varying COLLATE pg_catalog."default",
    "Rtmps_Stream_Url" character varying COLLATE pg_catalog."default",
    "Backup_Rtmps_Stream_Url" character varying COLLATE pg_catalog."default",
    "Is_Active" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Stream_Ended" character varying COLLATE pg_catalog."default",
    "Upcoming_Unique_Id" character varying COLLATE pg_catalog."default",
    "Access_Token" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_youtube_stream_detail PRIMARY KEY ("Youtube_Stream_Detail_Id"),
    CONSTRAINT fyoutubedtreamdetail_fk_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT youtubedtreamdetail_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Index: PK_Youtube_Stream_Detail

-- DROP INDEX IF EXISTS public."PK_Youtube_Stream_Detail";

CREATE INDEX IF NOT EXISTS "PK_Youtube_Stream_Detail"
    ON public."Youtube_Stream_Detail" USING btree
    ("Youtube_Stream_Detail_Id" ASC NULLS LAST)
    TABLESPACE pg_default;