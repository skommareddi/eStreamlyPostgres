
CREATE TABLE IF NOT EXISTS public."Like_History"
(
    "Like_History_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Live_Stream_Info_Id" bigint NOT NULL,
    "User_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Active" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'Y'::character varying,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_like_history PRIMARY KEY ("Like_History_Id"),
    CONSTRAINT like_history_fk_live_stream_info FOREIGN KEY ("Live_Stream_Info_Id")
        REFERENCES public."Live_Stream_Info" ("Live_Stream_Info_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Like_History"
    ON public."Like_History" USING btree
    ("Like_History_Id" ASC NULLS LAST)
    TABLESPACE pg_default;