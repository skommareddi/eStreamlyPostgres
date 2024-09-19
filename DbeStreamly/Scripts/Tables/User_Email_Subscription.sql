
CREATE TABLE IF NOT EXISTS public."User_Email_Subscription"
(
    "User_Email_Subscription_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Newsletter_Fl" boolean NOT NULL DEFAULT true,
    "Marketting_Email_Fl" boolean NOT NULL DEFAULT true,
    "Upcoming_Unique_Id" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_user_email_subscription PRIMARY KEY ("User_Email_Subscription_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_User_Email_Subscription"
    ON public."User_Email_Subscription" USING btree
    ("User_Email_Subscription_Id" ASC NULLS LAST)
    TABLESPACE pg_default;