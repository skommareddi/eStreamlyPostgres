
CREATE TABLE IF NOT EXISTS public."Poll_Notification"
(
    "Poll_Notification_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Poll_Info_Id" bigint NOT NULL,
    "User_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Viewed" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'N'::character varying,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_poll_notification PRIMARY KEY ("Poll_Notification_Id"),
    CONSTRAINT poll_notification_fk_poll_info FOREIGN KEY ("Poll_Info_Id")
        REFERENCES public."Poll_Info" ("Poll_Info_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Poll_Notification"
    ON public."Poll_Notification" USING btree
    ("Poll_Notification_Id" ASC NULLS LAST)
    TABLESPACE pg_default;