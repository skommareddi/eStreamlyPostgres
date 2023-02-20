
CREATE TABLE IF NOT EXISTS public."Video_Interactivity"
(
    "Video_Interactivity_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Video_Channel_Id" bigint NOT NULL,
    "Video_Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Channel_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Poll_Type" integer NOT NULL,
    "Poll_Time" numeric,
    "Ques_Desc" character varying COLLATE pg_catalog."default",
    "Ques_Options" character varying COLLATE pg_catalog."default",
    "Product_Id" bigint,
    "Information" character varying COLLATE pg_catalog."default",
    "ShoutOutValue" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_video_interactivity PRIMARY KEY ("Video_Interactivity_Id"),
    CONSTRAINT video_interactivity_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT video_interactivity_fk_videochannelid FOREIGN KEY ("Video_Channel_Id")
        REFERENCES public."Video_Channel" ("Video_Channel_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Video_Interactivity"
    ON public."Video_Interactivity" USING btree
    ("Video_Interactivity_Id" ASC NULLS LAST)
    TABLESPACE pg_default;