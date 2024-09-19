-- Table: public.Magento_Recaptcha_Config

-- DROP TABLE IF EXISTS public."Magento_Recaptcha_Config";

CREATE TABLE IF NOT EXISTS public."Magento_Recaptcha_Config"
(
    "Magento_Recaptcha_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Recaptcha_Type" character varying COLLATE pg_catalog."default",
    "Google_Website_Key" character varying COLLATE pg_catalog."default" NOT NULL,
    "Google_Secret_Key" character varying COLLATE pg_catalog."default" NOT NULL,
    "Captcha_Pages" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_magento_recaptcha_config PRIMARY KEY ("Magento_Recaptcha_Config_Id"),
    CONSTRAINT fk_magento_recaptcha_config_business FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)