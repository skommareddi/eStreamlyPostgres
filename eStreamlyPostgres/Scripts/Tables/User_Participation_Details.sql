
CREATE TABLE IF NOT EXISTS public."User_Participation_Details"
(
    "User_Participation_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "UserId" character varying COLLATE pg_catalog."default",
    "UniqueId" character varying COLLATE pg_catalog."default",
    "Type" character varying COLLATE pg_catalog."default",
    "Participated_Count" bigint,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Product_Id" bigint,
    "Description" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Product_Id_List" character varying COLLATE pg_catalog."default",
    "Customer_Id" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_user_participation_details PRIMARY KEY ("User_Participation_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_User_Participation_Details"
    ON public."User_Participation_Details" USING btree
    ("User_Participation_Id" ASC NULLS LAST)
    TABLESPACE pg_default;