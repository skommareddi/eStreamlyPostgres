﻿-- Table: public.Upcoming_Poll_Info

-- DROP TABLE IF EXISTS public."Upcoming_Poll_Info";

CREATE TABLE IF NOT EXISTS public."Upcoming_Poll_Info"
(
    "Upcoming_Poll_Info_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Channel_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Upcoming_Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Poll_Type" integer NOT NULL,
    "Poll_Info_Detail" text COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Is_Poll_Posted" boolean,
    "Product_Id" bigint,
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Information_Detail" character varying COLLATE pg_catalog."default",
    "Channel_Info_Id" bigint,
    "Product_Variant_List_Id" bigint,
    CONSTRAINT pk_upcoming_poll_info PRIMARY KEY ("Upcoming_Poll_Info_Id"),
    CONSTRAINT upcomingpollinfo_fk_channelinfoid FOREIGN KEY ("Channel_Info_Id")
        REFERENCES public."Channel_Info" ("Channel_Info_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);
-- Index: PK_Upcoming_Poll_Info

-- DROP INDEX IF EXISTS public."PK_Upcoming_Poll_Info";

CREATE INDEX IF NOT EXISTS "PK_Upcoming_Poll_Info"
    ON public."Upcoming_Poll_Info" USING btree
    ("Upcoming_Poll_Info_Id" ASC NULLS LAST)
    TABLESPACE pg_default;