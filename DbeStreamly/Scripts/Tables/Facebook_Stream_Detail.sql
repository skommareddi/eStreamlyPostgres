-- Table: public.Facebook_Stream_Detail

-- DROP TABLE IF EXISTS public."Facebook_Stream_Detail";

CREATE TABLE IF NOT EXISTS public."Facebook_Stream_Detail"
(
    "Facebook_Stream_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Live_Video_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Broadcast_Id" character varying COLLATE pg_catalog."default",
    "Stream_Key" character varying COLLATE pg_catalog."default",
    "Rtmp_Stream_Url" character varying COLLATE pg_catalog."default",
    "Secure_Stream_Url" character varying COLLATE pg_catalog."default",
    "Is_Stream_Ended" character varying COLLATE pg_catalog."default",
    "Upcoming_Unique_Id" character varying COLLATE pg_catalog."default",
    "Is_Active" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Access_Token" character varying COLLATE pg_catalog."default",
    "Is_Expired" character varying COLLATE pg_catalog."default" DEFAULT 'N'::character varying,
    "Page_Access_Token" character varying COLLATE pg_catalog."default",
    "Group_Access_Token" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_facebook_stream_detail PRIMARY KEY ("Facebook_Stream_Detail_Id"),
    CONSTRAINT facebookstreamdetail_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT facebookstreamdetail_fk_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "PK_Facebook_Stream_Detail"
    ON public."Facebook_Stream_Detail" USING btree
    ("Facebook_Stream_Detail_Id" ASC NULLS LAST)
    TABLESPACE pg_default;