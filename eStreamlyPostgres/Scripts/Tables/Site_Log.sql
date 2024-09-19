CREATE TABLE IF NOT EXISTS public."Site_Log"
(
    "Site_Log_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "User_Id" character varying COLLATE pg_catalog."default",
    "Guest_User_Id" character varying COLLATE pg_catalog."default",
    "Browser_Info" character varying COLLATE pg_catalog."default",
    "Device_Info" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Url" character varying COLLATE pg_catalog."default",
    "HostUrl" character varying COLLATE pg_catalog."default",
    "Active_Page" character varying COLLATE pg_catalog."default",
    "Description" character varying COLLATE pg_catalog."default",
    "InstagramSSTXId" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Site_Log_pkey" PRIMARY KEY ("Site_Log_Id")
)
