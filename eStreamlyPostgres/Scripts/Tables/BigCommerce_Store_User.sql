CREATE TABLE IF NOT EXISTS public."BigCommerce_Store_User"
(
    "BigCommerce_Store_User_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "BigCommerce_Store_Id" bigint NOT NULL,
    "BigCommerce_User_Id" bigint NOT NULL,
    "Is_Admin" boolean NOT NULL DEFAULT false,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Active" boolean NOT NULL DEFAULT true,
    CONSTRAINT pk_bigcommerce_store_user PRIMARY KEY ("BigCommerce_Store_User_Id"),
    CONSTRAINT bigcommercestoreuser_fk_bigcommercestoreid FOREIGN KEY ("BigCommerce_Store_Id")
        REFERENCES public."BigCommerce_Store_Detail" ("BigCommerce_Store_Detail_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT bigcommercestoreuser_fk_bigcommerceuserid FOREIGN KEY ("BigCommerce_User_Id")
        REFERENCES public."BigCommerce_User" ("BigCommerce_User_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);