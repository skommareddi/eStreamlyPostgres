
CREATE TABLE IF NOT EXISTS public."Business"
(
    "Business_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "UserName" character varying COLLATE pg_catalog."default" NOT NULL,
    "Business_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Business_Description" character varying COLLATE pg_catalog."default",
    "Business_Url" character varying COLLATE pg_catalog."default",
    "Business_Image" character varying COLLATE pg_catalog."default",
    "User_Id" character varying COLLATE pg_catalog."default",
    "Is_Active" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'Y'::character varying,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Is_Approved" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'N'::character varying,
    "Shortname" character varying COLLATE pg_catalog."default",
    "Background_Image" character varying COLLATE pg_catalog."default",
    "First_Name" character varying COLLATE pg_catalog."default",
    "Last_Name" character varying COLLATE pg_catalog."default",
    "Order_Management_Sytem" character varying COLLATE pg_catalog."default",
    "Is_Cbd_Product" boolean,
    "Phone_Number" character varying COLLATE pg_catalog."default",
    "Stripe_Connect_Account_Id" character varying COLLATE pg_catalog."default",
    "Cut_Percentage" numeric,
    "Cut_Amount" numeric,
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Nexio_Payment_Gateway" character varying COLLATE pg_catalog."default",
    "PaymentGateway_Api_Login_Id" character varying COLLATE pg_catalog."default",
    "PaymentGateway_Transaction_Key" character varying COLLATE pg_catalog."default",
    "Store_Url" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_business PRIMARY KEY ("Business_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "PK_Business"
    ON public."Business" USING btree
    ("Business_Id" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "Shortname"
    ON public."Business" USING btree
    ("Shortname" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;