CREATE TABLE public."AWS_Entitlement" (
    "AWS_Entitlement_Id" bigint NOT NULL,
    "Dimension" character varying NOT NULL,
    "CustomerIdentifier" character varying NOT NULL,
    "ExpirationDate" timestamp with time zone NOT NULL,
    "ProductCode" character varying NOT NULL,
    "EntitlementValue" character varying NOT NULL,
    "Is_Active" boolean DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying,
    "Record_Version" numeric DEFAULT 1 NOT NULL
);


ALTER TABLE public."AWS_Entitlement" ALTER COLUMN "AWS_Entitlement_Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."AWS_Entitlement_AWS_Entitlement_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);