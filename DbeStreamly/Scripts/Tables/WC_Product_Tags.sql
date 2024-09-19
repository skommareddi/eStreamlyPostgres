
CREATE TABLE IF NOT EXISTS public."WC_Product_Tags"
(
    "Product_Tag_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "WC_Product_Tag_Id" bigint NOT NULL,
    "WC_Product_Id" bigint NOT NULL,
    "Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_wc_product_tags PRIMARY KEY ("Product_Tag_Id"),
    CONSTRAINT wcproducttag_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."WC_Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_WC_Product_Tags"
    ON public."WC_Product_Tags" USING btree
    ("Product_Tag_Id" ASC NULLS LAST)
    TABLESPACE pg_default;