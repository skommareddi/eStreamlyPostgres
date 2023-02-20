-- Table: public.Instagram_Stream_Detail

-- DROP TABLE IF EXISTS public."Instagram_Stream_Detail";

CREATE TABLE IF NOT EXISTS public."Instagram_Stream_Detail"
(
    "Instagram_Stream_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Stream_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Broadcast_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Stream_Key" character varying COLLATE pg_catalog."default",
    "Rtmp_Stream_Url" character varying COLLATE pg_catalog."default",
    "Is_Stream_Ended" character varying COLLATE pg_catalog."default",
    "Upcoming_Unique_Id" character varying COLLATE pg_catalog."default",
    "Is_Active" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Comment_Sent" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_instagram_stream_detail PRIMARY KEY ("Instagram_Stream_Detail_Id"),
    CONSTRAINT instagramstreamdetail_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "PK_Instagram_Stream_Detail"
    ON public."Instagram_Stream_Detail" USING btree
    ("Instagram_Stream_Detail_Id" ASC NULLS LAST)
    TABLESPACE pg_default;