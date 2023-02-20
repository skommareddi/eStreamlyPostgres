
CREATE TABLE IF NOT EXISTS public."MediaByUserAndChannel"
(
    "Media_Item_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "User_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Channel_Id" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'PreRecorded'::character varying,
    "Item_Id" bigint,
    "Media_Url" character varying COLLATE pg_catalog."default",
    "Media_thumbnail_Url" character varying COLLATE pg_catalog."default",
    "Media_thumbnailGif_Url" character varying COLLATE pg_catalog."default",
    "CreatedDate" timestamp with time zone NOT NULL DEFAULT now(),
    "CreatedBy" character varying COLLATE pg_catalog."default",
    "ModifiedDate" timestamp with time zone,
    "ModifiedBy" character varying COLLATE pg_catalog."default",
    "Channel_Desc" character varying COLLATE pg_catalog."default",
    "Media_Unique_Id" character varying COLLATE pg_catalog."default",
    "Desktop_Image_Url" character varying COLLATE pg_catalog."default",
    "Mobile_Image_Url" character varying COLLATE pg_catalog."default",
    "Tablet_Image_Url" character varying COLLATE pg_catalog."default",
    "Channel_Name" character varying COLLATE pg_catalog."default",
    "Upcoming_Unique_Id" character varying COLLATE pg_catalog."default",
    "DurationInSeconds" bigint,
    "Duration" timestamp with time zone,
    keywords character varying COLLATE pg_catalog."default",
    "Transcript_File_Url" character varying COLLATE pg_catalog."default",
    "SRT_File_Url" character varying COLLATE pg_catalog."default",
    "VTT_File_Url" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Modified_Title" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_mediabyuserandchannel PRIMARY KEY ("Media_Item_Id"),
    CONSTRAINT mediabyuserandchannel_fk_userid FOREIGN KEY ("User_Id")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "Media_Unique_Id"
    ON public."MediaByUserAndChannel" USING btree
    ("Media_Unique_Id" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "PK_MediaByUserAndChannel"
    ON public."MediaByUserAndChannel" USING btree
    ("Media_Item_Id" ASC NULLS LAST)
    TABLESPACE pg_default;