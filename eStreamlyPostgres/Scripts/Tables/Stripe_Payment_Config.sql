CREATE TABLE IF NOT EXISTS public."Stripe_Payment_Config"
(
    "Stripe_Payment_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Stripe_Secret_Key" character varying COLLATE pg_catalog."default",
    "Stripe_Publishable_Key" character varying COLLATE pg_catalog."default",
    "Is_Active" boolean DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "Stripe_Payment_Config_pkey" PRIMARY KEY ("Stripe_Payment_Config_Id"),
    CONSTRAINT "Stripe_Payment_Config_fk_Business" FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);