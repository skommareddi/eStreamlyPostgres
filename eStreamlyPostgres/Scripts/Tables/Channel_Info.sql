
CREATE TABLE IF NOT EXISTS public."Channel_Info"
(
    "Channel_Info_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Channel_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "User_Id" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Channel_Name" character varying COLLATE pg_catalog."default",
    "Channel_Desc" character varying COLLATE pg_catalog."default",
    "Media_Unique_Id" character varying COLLATE pg_catalog."default",
    "Business_Id" bigint,
    "Channel_Stream_Status" character varying COLLATE pg_catalog."default" DEFAULT 'OFFLINE'::character varying,
    "PlaybackUrl" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_channel_info PRIMARY KEY ("Channel_Info_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "NonClusteredIndex-20210827-100012"
    ON public."Channel_Info" USING btree
    ("Channel_Id" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "NonClusteredIndex-20210827-100027"
    ON public."Channel_Info" USING btree
    ("Channel_Info_Id" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Channel_Info"
    ON public."Channel_Info" USING btree
    ("Channel_Info_Id" ASC NULLS LAST)
    TABLESPACE pg_default;