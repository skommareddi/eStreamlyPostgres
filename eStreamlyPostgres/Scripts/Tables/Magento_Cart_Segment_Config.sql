-- Table: public.Magento_Cart_Segment_Config

-- DROP TABLE IF EXISTS public."Magento_Cart_Segment_Config";

CREATE TABLE IF NOT EXISTS public."Magento_Cart_Segment_Config"
(
    "Magento_Cart_Segment_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Code" character varying COLLATE pg_catalog."default",
    "Title" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_magento_cart_segment_config PRIMARY KEY ("Magento_Cart_Segment_Config_Id")
)