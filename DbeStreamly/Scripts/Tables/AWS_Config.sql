CREATE TABLE public."AWS_Config" (
    "AWS_Config_Id" bigint NOT NULL,
    "Config_Name" character varying NOT NULL,
    "Config_Value" character varying NOT NULL,
    "Is_Active" boolean DEFAULT true,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying,
    "Record_Version" numeric DEFAULT 1 NOT NULL
);


ALTER TABLE public."AWS_Config" ALTER COLUMN "AWS_Config_Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."AWS_Config_AWS_Config_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);