-- Table: public.Live_Stream_Info

-- DROP TABLE IF EXISTS public."Live_Stream_Info";

CREATE TABLE IF NOT EXISTS public."Live_Stream_Info"
(
    "Live_Stream_Info_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Channel_Info_Id" bigint NOT NULL,
    "Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Start_Time" timestamp with time zone NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Like_Count" bigint,
    "Utc_Start_Time" timestamp with time zone,
    "Stream_Id" character varying COLLATE pg_catalog."default",
    "Upcoming_Unique_Id" character varying COLLATE pg_catalog."default",
    "Viewer_Count" bigint,
    "Room_Info" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Stream_Ended" boolean,
    CONSTRAINT pk_live_stream_info PRIMARY KEY ("Live_Stream_Info_Id"),
    CONSTRAINT live_stream_info_fk_channel_info FOREIGN KEY ("Channel_Info_Id")
        REFERENCES public."Channel_Info" ("Channel_Info_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Index: IX_live_stream_info_Unique_Id

-- DROP INDEX IF EXISTS public."IX_live_stream_info_Unique_Id";

CREATE INDEX IF NOT EXISTS "IX_live_stream_info_Unique_Id"
    ON public."Live_Stream_Info" USING btree
    ("Unique_Id" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: Live_Channel

-- DROP INDEX IF EXISTS public."Live_Channel";

CREATE INDEX IF NOT EXISTS "Live_Channel"
    ON public."Live_Stream_Info" USING btree
    ("Channel_Info_Id" ASC NULLS LAST, "Unique_Id" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: NonClusteredIndex-20210827-100105

-- DROP INDEX IF EXISTS public."NonClusteredIndex-20210827-100105";

CREATE INDEX IF NOT EXISTS "NonClusteredIndex-20210827-100105"
    ON public."Live_Stream_Info" USING btree
    ("Unique_Id" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: NonClusteredIndex-20210827-100311

-- DROP INDEX IF EXISTS public."NonClusteredIndex-20210827-100311";

CREATE INDEX IF NOT EXISTS "NonClusteredIndex-20210827-100311"
    ON public."Live_Stream_Info" USING btree
    ("Channel_Info_Id" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: NonClusteredIndex-20210827-100347

-- DROP INDEX IF EXISTS public."NonClusteredIndex-20210827-100347";

CREATE INDEX IF NOT EXISTS "NonClusteredIndex-20210827-100347"
    ON public."Live_Stream_Info" USING btree
    ("Live_Stream_Info_Id" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: PK_Live_Stream_Info

-- DROP INDEX IF EXISTS public."PK_Live_Stream_Info";

CREATE INDEX IF NOT EXISTS "PK_Live_Stream_Info"
    ON public."Live_Stream_Info" USING btree
    ("Live_Stream_Info_Id" ASC NULLS LAST)
    TABLESPACE pg_default;