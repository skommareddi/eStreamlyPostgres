CREATE TABLE IF NOT EXISTS public."AWS_Entitlement"
(
    "AWS_Entitlement_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Dimension" character varying COLLATE pg_catalog."default" NOT NULL,
    "CustomerIdentifier" character varying COLLATE pg_catalog."default" NOT NULL,
    "ExpirationDate" timestamp with time zone NOT NULL,
    "ProductCode" character varying COLLATE pg_catalog."default" NOT NULL,
    "EntitlementValue" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Active" boolean DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "pk_AWS_Entitlement" PRIMARY KEY ("AWS_Entitlement_Id")
);