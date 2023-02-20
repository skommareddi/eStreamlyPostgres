
CREATE TABLE IF NOT EXISTS public."User_Browser_Detail"
(
    "User_Browser_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Browser" character varying COLLATE pg_catalog."default" NOT NULL,
    "IP_Address" character varying COLLATE pg_catalog."default",
    "Version" character varying COLLATE pg_catalog."default",
    "OS" character varying COLLATE pg_catalog."default",
    "Is_IFrame" character varying COLLATE pg_catalog."default",
    "IFrame_Parent_Url" character varying COLLATE pg_catalog."default",
    "Others" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "User_Browser_Detail_pkey" PRIMARY KEY ("User_Browser_Detail_Id"),
    CONSTRAINT userbrowserhistory_fk_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;
