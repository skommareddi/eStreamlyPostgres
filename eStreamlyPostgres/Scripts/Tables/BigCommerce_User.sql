﻿CREATE TABLE IF NOT EXISTS public."BigCommerce_User"
(
    "BigCommerce_User_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "BC_User_Id" bigint NOT NULL,
    "Email" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Active" boolean NOT NULL DEFAULT true,
    CONSTRAINT "BigCommerce_User_pkey" PRIMARY KEY ("BigCommerce_User_Id")
);