
CREATE TABLE IF NOT EXISTS public."Business_Review"
(
    "Business_Review_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "User_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Review_Rating" numeric NOT NULL DEFAULT 0,
    "Review_Title" character varying COLLATE pg_catalog."default" NOT NULL,
    "Review_Detail" text COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_business_review PRIMARY KEY ("Business_Review_Id"),
    CONSTRAINT businessreview_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Business_Review"
    ON public."Business_Review" USING btree
    ("Business_Review_Id" ASC NULLS LAST)
    TABLESPACE pg_default;