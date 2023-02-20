﻿
CREATE TABLE IF NOT EXISTS public."User_CateogoryOfInterest"
(
    "Category_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_User_Id" bigint NOT NULL,
    "Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_user_cateogoryofinterest PRIMARY KEY ("Category_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_User_CateogoryOfInterest"
    ON public."User_CateogoryOfInterest" USING btree
    ("Category_Id" ASC NULLS LAST)
    TABLESPACE pg_default;