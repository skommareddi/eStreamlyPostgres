
CREATE TABLE IF NOT EXISTS public."Event_Reminder"
(
    "Event_Reminder_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "User_Phone" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Unique_Id" character varying COLLATE pg_catalog."default",
    "Business_Id" bigint,
    "Country_Code" character varying COLLATE pg_catalog."default",
    "Notified_Fl" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_event_reminder PRIMARY KEY ("Event_Reminder_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Event_Reminder"
    ON public."Event_Reminder" USING btree
    ("Event_Reminder_Id" ASC NULLS LAST)
    TABLESPACE pg_default;