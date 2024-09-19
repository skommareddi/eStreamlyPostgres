-- Table: public.Social_Media_Handle_Config

-- DROP TABLE IF EXISTS public."Social_Media_Handle_Config";

CREATE TABLE IF NOT EXISTS public."Social_Media_Handle_Config"
(
    "Social_Media_Handle_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "RTMP_Server_Config_Id" bigint NOT NULL,
    "Social_Media_Handle" character varying COLLATE pg_catalog."default" NOT NULL,
    "Stream_Key" character varying COLLATE pg_catalog."default" NOT NULL,
    "Stream_Url" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Live" boolean NOT NULL,
    "Is_Active" boolean NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "pk_Social_Media_Handle_Config" PRIMARY KEY ("Social_Media_Handle_Config_Id"),
    CONSTRAINT "fk_Social_Media_Handle_Config_Business" FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "fk_Social_Media_Handle_Config_RTMP_Server_Congig" FOREIGN KEY ("RTMP_Server_Config_Id")
        REFERENCES public."RTMP_Server_Config" ("RTMP_Server_Config_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);