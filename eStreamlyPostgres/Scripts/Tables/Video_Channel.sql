-- Table: public.Video_Channel

-- DROP TABLE IF EXISTS public."Video_Channel";

CREATE TABLE IF NOT EXISTS public."Video_Channel"
(
    "Video_Channel_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Video_Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Business_Id" bigint NOT NULL,
    "Channel_Id" character varying COLLATE pg_catalog."default",
    "Video_Url" character varying COLLATE pg_catalog."default" NOT NULL,
    "Video_Gif_Url" character varying COLLATE pg_catalog."default",
    "Video_Thumbnail_Url" character varying COLLATE pg_catalog."default",
    "Desktop_Thumbnail_Url" character varying COLLATE pg_catalog."default",
    "Tablet_Thumbnail_Url" character varying COLLATE pg_catalog."default",
    "Mobile_Thumbnail_Url" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "M3U8_Video_Url" character varying COLLATE pg_catalog."default",
    "Title" character varying COLLATE pg_catalog."default",
    "Description" character varying COLLATE pg_catalog."default",
    "Viewer_Count" bigint,
    "Likes_Count" bigint,
    "User_Id" character varying COLLATE pg_catalog."default",
    "Duration" integer,
    "Is_Active" boolean,
    "Keywords" character varying COLLATE pg_catalog."default",
    "Transcript_File_Url" character varying COLLATE pg_catalog."default",
    "Srt_File_Url" character varying COLLATE pg_catalog."default",
    "Vtt_File_Url" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Modified_Title" character varying COLLATE pg_catalog."default",
    "Channel_Info_Id" bigint,
    CONSTRAINT pk_video_channel PRIMARY KEY ("Video_Channel_Id"),
    CONSTRAINT fk_video_channel_video_channel FOREIGN KEY ("Video_Channel_Id")
        REFERENCES public."Video_Channel" ("Video_Channel_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT videochannel_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT videochannel_fk_channelinfoid FOREIGN KEY ("Channel_Info_Id")
        REFERENCES public."Channel_Info" ("Channel_Info_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);
-- Index: PK_Video_Channel

-- DROP INDEX IF EXISTS public."PK_Video_Channel";

CREATE INDEX IF NOT EXISTS "PK_Video_Channel"
    ON public."Video_Channel" USING btree
    ("Video_Channel_Id" ASC NULLS LAST)
    TABLESPACE pg_default;