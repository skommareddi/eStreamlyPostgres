
CREATE TABLE IF NOT EXISTS public."Product_Video"
(
    "Product_Video_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Video_Url" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_product_video PRIMARY KEY ("Product_Video_Id"),
    CONSTRAINT productvideo_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Product_Video"
    ON public."Product_Video" USING btree
    ("Product_Video_Id" ASC NULLS LAST)
    TABLESPACE pg_default;