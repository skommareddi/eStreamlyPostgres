
CREATE TABLE IF NOT EXISTS public."User_Comments"
(
    "User_Comments_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Live_Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Comment" character varying COLLATE pg_catalog."default",
    "Comment_Audio_Url" character varying COLLATE pg_catalog."default",
    "Category_Id" bigint,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_user_comments PRIMARY KEY ("User_Comments_Id"),
    CONSTRAINT usercomments_fk_categoryid FOREIGN KEY ("Category_Id")
        REFERENCES public."Comment_Category" ("Comment_Category_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT usercomments_fk_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_User_Comments"
    ON public."User_Comments" USING btree
    ("User_Comments_Id" ASC NULLS LAST)
    TABLESPACE pg_default;