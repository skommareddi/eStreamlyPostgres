CREATE TABLE IF NOT EXISTS public."AWS_Config"
(
    "AWS_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Config_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Config_Value" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Active" boolean DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "pk_AWS_Config" PRIMARY KEY ("AWS_Config_Id")
);