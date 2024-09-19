
CREATE TABLE IF NOT EXISTS public."Product_Review"
(
    "Product_Review_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Review_Rating" numeric,
    "Review_Detail" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "User_Name" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_product_review PRIMARY KEY ("Product_Review_Id"),
    CONSTRAINT productreview_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT productreview_fk_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Product_Review"
    ON public."Product_Review" USING btree
    ("Product_Review_Id" ASC NULLS LAST)
    TABLESPACE pg_default;