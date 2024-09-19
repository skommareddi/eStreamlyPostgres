
CREATE TABLE IF NOT EXISTS public."Business_User"
(
    "Business_User_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "UserName" character varying COLLATE pg_catalog."default" NOT NULL,
    "Company" character varying COLLATE pg_catalog."default" NOT NULL,
    "Phone" character varying COLLATE pg_catalog."default" NOT NULL,
    "Email" character varying COLLATE pg_catalog."default" NOT NULL,
    "Role" character varying COLLATE pg_catalog."default" NOT NULL,
    "Instagram_Id" character varying COLLATE pg_catalog."default",
    "Youtube_Id" character varying COLLATE pg_catalog."default",
    "Tiktok_Id" character varying COLLATE pg_catalog."default",
    "Facebook_Id" character varying COLLATE pg_catalog."default",
    "Twitter_Id" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_business_user PRIMARY KEY ("Business_User_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Business_User"
    ON public."Business_User" USING btree
    ("Business_User_Id" ASC NULLS LAST)
    TABLESPACE pg_default;