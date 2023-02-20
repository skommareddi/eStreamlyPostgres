﻿
CREATE TABLE IF NOT EXISTS public."Poll_Info"
(
    "Poll_Info_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Channel_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Poll_Type" integer NOT NULL,
    "Poll_Info_Detail" text COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Poll_Elapsed_Time" numeric,
    "Unique_Id" character varying COLLATE pg_catalog."default",
    "Product_Id" bigint,
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_poll_info PRIMARY KEY ("Poll_Info_Id"),
    CONSTRAINT poll_info_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Poll_Info"
    ON public."Poll_Info" USING btree
    ("Poll_Info_Id" ASC NULLS LAST)
    TABLESPACE pg_default;