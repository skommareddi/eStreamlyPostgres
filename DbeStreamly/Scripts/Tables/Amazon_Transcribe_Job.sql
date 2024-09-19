CREATE TABLE public."Amazon_Transcribe_Job" (
    "Amazon_Transcribe_Job_Id" bigint NOT NULL,
    "Job_Id" character varying,
    "Asset_Id" character varying,
    "Video_Url" character varying,
    "SRT_File_Url" character varying,
    "VTT_File_Url" character varying,
    "Text_File_Url" character varying,
    "Job_Status" character varying,
    "Job_Started_Time" timestamp with time zone,
    "Job_Completed_Time" timestamp with time zone,
    "Created_Date" timestamp with time zone DEFAULT now() NOT NULL,
    "Created_By" character varying DEFAULT ''::character varying NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying,
    "Record_Version" numeric DEFAULT 1 NOT NULL
);


ALTER TABLE public."Amazon_Transcribe_Job" ALTER COLUMN "Amazon_Transcribe_Job_Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."Amazon_Transcribe_Job_Amazon_Transcribe_Job_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);