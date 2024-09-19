CREATE TABLE public."AWS_Customer" (
    "AWS_Customer_Id" bigint NOT NULL,
    "CustomerAWSAccountId" character varying NOT NULL,
    "CustomerIdentifier" character varying NOT NULL,
    "ProductCode" character varying NOT NULL,
    "Is_Active" boolean DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying,
    "Record_Version" numeric DEFAULT 1 NOT NULL,
    "Business_Id" bigint
);

ALTER TABLE public."AWS_Customer" ALTER COLUMN "AWS_Customer_Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."AWS_Customer_AWS_Customer_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);