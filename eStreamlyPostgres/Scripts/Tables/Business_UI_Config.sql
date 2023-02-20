-- Table: public.Business_UI_Config

-- DROP TABLE IF EXISTS public."Business_UI_Config";

CREATE TABLE IF NOT EXISTS public."Business_UI_Config"
(
    "Business_UI_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Config_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Config_Value" character varying COLLATE pg_catalog."default" NOT NULL,
    "Application_Page" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Active" boolean DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "pk_Business_ui_Config" PRIMARY KEY ("Business_UI_Config_Id"),
    CONSTRAINT config_unique_col UNIQUE ("Business_Id", "Config_Name", "Application_Page"),
    CONSTRAINT "Business_UI_Config_fk_Business" FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);