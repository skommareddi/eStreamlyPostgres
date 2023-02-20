
CREATE TABLE IF NOT EXISTS public."Live_Chat"
(
    "Live_Chat_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "ChatId" character varying COLLATE pg_catalog."default",
    "UserId" character varying COLLATE pg_catalog."default",
    "AttendeeName" character varying COLLATE pg_catalog."default",
    "UserImg" character varying COLLATE pg_catalog."default",
    "Data" character varying COLLATE pg_catalog."default",
    "Title" character varying COLLATE pg_catalog."default",
    "Inactive" character varying COLLATE pg_catalog."default",
    "TTL" timestamp with time zone,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_live_chat PRIMARY KEY ("Live_Chat_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Live_Chat"
    ON public."Live_Chat" USING btree
    ("Live_Chat_Id" ASC NULLS LAST)
    TABLESPACE pg_default;