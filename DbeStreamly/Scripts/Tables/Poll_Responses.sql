-- Table: public.Poll_Responses

-- DROP TABLE IF EXISTS public."Poll_Responses";

CREATE TABLE IF NOT EXISTS public."Poll_Responses"
(
    "Poll_Response_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Poll_Info_Id" bigint NOT NULL,
    "User_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Response_Info" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_poll_responses PRIMARY KEY ("Poll_Response_Id"),
    CONSTRAINT poll_responses_fk_poll_info FOREIGN KEY ("Poll_Info_Id")
        REFERENCES public."Poll_Info" ("Poll_Info_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT poll_responses_fk_user FOREIGN KEY ("User_Id")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
-- Index: PK_Poll_Responses

-- DROP INDEX IF EXISTS public."PK_Poll_Responses";

CREATE INDEX IF NOT EXISTS "PK_Poll_Responses"
    ON public."Poll_Responses" USING btree
    ("Poll_Response_Id" ASC NULLS LAST)
    TABLESPACE pg_default;