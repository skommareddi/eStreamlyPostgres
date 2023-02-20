
CREATE TABLE IF NOT EXISTS public."Upcoming_Live_Stream"
(
    "Upcoming_Live_Stream_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Description" character varying COLLATE pg_catalog."default",
    "Channel_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Media_Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Start_Date_Time" timestamp with time zone NOT NULL,
    "End_Date_Time" timestamp with time zone,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "User_Id" character varying COLLATE pg_catalog."default",
    "Event_Image" character varying COLLATE pg_catalog."default",
    "Desktop_Image_Url" character varying COLLATE pg_catalog."default",
    "Mobile_Image_Url" character varying COLLATE pg_catalog."default",
    "Tablet_Image_Url" character varying COLLATE pg_catalog."default",
    "Event_Video_Url" character varying COLLATE pg_catalog."default",
    "Event_Video_Gif_Url" character varying COLLATE pg_catalog."default",
    "Is_Private_Event" boolean DEFAULT false,
    "Is_Active" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Keywords" character varying COLLATE pg_catalog."default",
    "Is_Live_Stream_Available" boolean DEFAULT false,
    "Is_Recording_Available" boolean DEFAULT false,
    CONSTRAINT pk_upcoming_livestream PRIMARY KEY ("Upcoming_Live_Stream_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Upcoming_LiveStream"
    ON public."Upcoming_Live_Stream" USING btree
    ("Upcoming_Live_Stream_Id" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "Upcoming_Live_Stream_Unique_Id"
    ON public."Upcoming_Live_Stream" USING btree
    ("Media_Unique_Id" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;