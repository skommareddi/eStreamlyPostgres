
CREATE TABLE IF NOT EXISTS public."Business_Video"
(
    "Business_Video_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Channel_Id" character varying COLLATE pg_catalog."default" NOT NULL,
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
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_business_video PRIMARY KEY ("Business_Video_Id"),
    CONSTRAINT businessvideo_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Business_Video"
    ON public."Business_Video" USING btree
    ("Business_Video_Id" ASC NULLS LAST)
    TABLESPACE pg_default;