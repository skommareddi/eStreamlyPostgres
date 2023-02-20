
CREATE TABLE IF NOT EXISTS public."Video_Interactivity_Response"
(
    "Video_Interactivity_Response_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Video_Interactivity_Id" bigint NOT NULL,
    "User_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Response_Info" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_video_interactivity_response PRIMARY KEY ("Video_Interactivity_Response_Id"),
    CONSTRAINT video_interactivity_response_fk_user FOREIGN KEY ("User_Id")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT video_interactivity_response_fk_video_interactivity FOREIGN KEY ("Video_Interactivity_Id")
        REFERENCES public."Video_Interactivity" ("Video_Interactivity_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Video_Interactivity_Response"
    ON public."Video_Interactivity_Response" USING btree
    ("Video_Interactivity_Response_Id" ASC NULLS LAST)
    TABLESPACE pg_default;