-- Table: public.Social_Media_Connection

-- DROP TABLE IF EXISTS public."Social_Media_Connection";

CREATE TABLE IF NOT EXISTS public."Social_Media_Connection"
(
    "Social_Media_Connection_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Social_Media_Handle" character varying COLLATE pg_catalog."default" NOT NULL,
    "Access_Token" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Active" boolean NOT NULL DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "User_Name" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Social_Media_Connection_pkey" PRIMARY KEY ("Social_Media_Connection_Id"),
    CONSTRAINT "SocialMediaConnection_fk_businessid" FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);