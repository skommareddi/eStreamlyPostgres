CREATE TABLE IF NOT EXISTS public."Stripe_Connect_Config"
(
    "Stripe_Connect_Config_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Stripe_Connect_Account_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Stripe_Cut_Percentage" numeric NOT NULL,
    "Stripe_Cut_Amount" numeric,
    "Is_Active" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "pk_Stripe_Connect_Config" PRIMARY KEY ("Stripe_Connect_Config_Id"),
    CONSTRAINT stripeconnectconfig_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;