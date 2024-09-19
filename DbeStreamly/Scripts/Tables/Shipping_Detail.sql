
CREATE TABLE IF NOT EXISTS public."Shipping_Detail"
(
    "Shipping_Detail_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "Weight_From" bigint NOT NULL,
    "Amount" numeric NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Distance" bigint,
    "Weight_To" bigint,
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_shipping_detail PRIMARY KEY ("Shipping_Detail_Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Shipping_Detail"
    ON public."Shipping_Detail" USING btree
    ("Shipping_Detail_Id" ASC NULLS LAST)
    TABLESPACE pg_default;