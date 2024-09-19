CREATE TABLE IF NOT EXISTS public."Bigcommerce_Onboard_Prerequisites"
(
    "Bigcommerce_Onboard_Prerequisites_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Storehash" character varying COLLATE pg_catalog."default",
    "Is_Shipping_to_US" boolean NOT NULL DEFAULT false,
    "Operating_Country" character varying COLLATE pg_catalog."default",
    "Is_Stripe" boolean NOT NULL DEFAULT false,
    "Payment_Processor" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "UserId" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Bigcommerce_Onboard_Prerequisites_pkey" PRIMARY KEY ("Bigcommerce_Onboard_Prerequisites_Id")
);