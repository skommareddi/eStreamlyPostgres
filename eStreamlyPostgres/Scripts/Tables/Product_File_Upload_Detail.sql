-- Table: public.Product_File_Upload_Detail

-- DROP TABLE IF EXISTS public."Product_File_Upload_Detail";

CREATE TABLE IF NOT EXISTS public."Product_File_Upload_Detail"
(
    "Product_File_Upload_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_id" bigint NOT NULL,
    "File_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "No_Of_Rows" bigint,
    "Uploaded_Date" timestamp with time zone,
    "Upload_Start_Time" timestamp with time zone,
    "Upload_End_Time" timestamp with time zone,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Is_Active" boolean,
    "Description" character varying COLLATE pg_catalog."default",
    CONSTRAINT "Product_File_Upload_Detail_pkey" PRIMARY KEY ("Product_File_Upload_Detail_Id")
)