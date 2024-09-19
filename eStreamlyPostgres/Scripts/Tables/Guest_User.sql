-- Table: public.Guest_User

-- DROP TABLE IF EXISTS public."Guest_User";

CREATE TABLE IF NOT EXISTS public."Guest_User"
(
    "Guest_User_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Session_User_Id" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Active" boolean NOT NULL DEFAULT true,
    "Guest_User_Name" character varying COLLATE pg_catalog."default",
    "UserId" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Guest_User_pkey" PRIMARY KEY ("Guest_User_Id")
);