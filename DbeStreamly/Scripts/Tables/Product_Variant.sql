
CREATE TABLE IF NOT EXISTS public."Product_Variant"
(
    "Product_Variant_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Variant_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Product_Variant_List" character varying COLLATE pg_catalog."default" NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_product_variant PRIMARY KEY ("Product_Variant_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Product_Variant"
    ON public."Product_Variant" USING btree
    ("Product_Variant_Id" ASC NULLS LAST)
    TABLESPACE pg_default;