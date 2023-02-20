CREATE TABLE IF NOT EXISTS public."BigCommerce_Store_Detail"
(
    "BigCommerce_Store_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Store_Hash" character varying COLLATE pg_catalog."default" NOT NULL,
    "Domain" character varying COLLATE pg_catalog."default" NOT NULL,
    "Secure_Url" character varying COLLATE pg_catalog."default" NOT NULL,
    "Status" character varying COLLATE pg_catalog."default" NOT NULL,
    "Store_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "First_Name" character varying COLLATE pg_catalog."default",
    "Last_Name" character varying COLLATE pg_catalog."default",
    "Email" character varying COLLATE pg_catalog."default",
    "Phone" character varying COLLATE pg_catalog."default",
    "Currency" character varying COLLATE pg_catalog."default",
    "Is_Price_Entered_With_Tax" boolean,
    "Scope" character varying COLLATE pg_catalog."default",
    "Access_Token" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    "Account_UUID" character varying COLLATE pg_catalog."default",
    "Store_Url" character varying COLLATE pg_catalog."default",
    "Is_Uninstalled" boolean,
    "Business_Id" bigint,
    "Is_Onboard_Completed" boolean,
    CONSTRAINT pk_bigcommerce_store_detail PRIMARY KEY ("BigCommerce_Store_Detail_Id"),
    CONSTRAINT "bigcommercestore_IN_storehash" UNIQUE ("Store_Hash"),
    CONSTRAINT bigcommercestore_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);