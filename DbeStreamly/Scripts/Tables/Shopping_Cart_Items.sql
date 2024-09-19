
CREATE TABLE IF NOT EXISTS public."Shopping_Cart_Items"
(
    "Shopping_Cart_Items_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Shopping_Cart_Id" bigint NOT NULL,
    "Product_Id" bigint NOT NULL,
    "Product_Variant_List_Id" bigint NOT NULL,
    "Quantity" integer NOT NULL,
    "Item_Removed_Date" timestamp with time zone,
    "Is_Active" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'Y'::character varying,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    "Media_Unique_Id" character varying COLLATE pg_catalog."default",
    "Business_Id" bigint,
    CONSTRAINT "Shopping_Cart_Items_pkey" PRIMARY KEY ("Shopping_Cart_Items_Id"),
    CONSTRAINT "Cart_Items_fk_Business_Id" FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT "Cart_Items_fk_Product_Id" FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Cart_Items_fk_Product_Variant_List_Id" FOREIGN KEY ("Product_Variant_List_Id")
        REFERENCES public."Product_Variant_List" ("Product_Variant_List_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Cart_Items_fk_Shopping_Cart_Id" FOREIGN KEY ("Shopping_Cart_Id")
        REFERENCES public."Shopping_Cart" ("Shopping_Cart_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "fki_Cart_Items_fk_Product_Id"
    ON public."Shopping_Cart_Items" USING btree
    ("Product_Id" ASC NULLS LAST)
    TABLESPACE pg_default;