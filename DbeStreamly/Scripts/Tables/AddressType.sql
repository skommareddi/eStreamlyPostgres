CREATE TABLE public."Address_Type" (
    "Address_Type_Id" integer NOT NULL,
    "Address_Type_Description" character varying NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying,
    "Record_Version" numeric DEFAULT 1 NOT NULL
);
