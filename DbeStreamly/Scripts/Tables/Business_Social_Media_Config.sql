
CREATE TABLE IF NOT EXISTS public."Business_Social_Media_Config"
(
    "Business_Social_Media_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Social_media_Handle" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Active" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'Y'::character varying,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_business_social_media_config PRIMARY KEY ("Business_Social_Media_Config_Id"),
    CONSTRAINT businesssocialmediaconfig_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;