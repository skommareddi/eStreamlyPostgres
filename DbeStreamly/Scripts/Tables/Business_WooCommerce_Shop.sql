
CREATE TABLE IF NOT EXISTS public."Business_WooCommerce_Shop"
(
    "Business_WooCommerce_Shop_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "WP_Host_Url" character varying COLLATE pg_catalog."default",
    "Consumer_Key" character varying COLLATE pg_catalog."default" NOT NULL,
    "Consumer_Secret_Key" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_business_woocommerce_shop PRIMARY KEY ("Business_WooCommerce_Shop_Id"),
    CONSTRAINT businesswoocommerceshop_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Business_WooCommerce_Shop"
    ON public."Business_WooCommerce_Shop" USING btree
    ("Business_WooCommerce_Shop_Id" ASC NULLS LAST)
    TABLESPACE pg_default;