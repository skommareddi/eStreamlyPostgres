
CREATE TABLE IF NOT EXISTS public."Order_Item"
(
    "Order_Item_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Poll_Info_Id" bigint NOT NULL,
    "Item_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Item_Type" character varying COLLATE pg_catalog."default" NOT NULL,
    "Item_Description" character varying COLLATE pg_catalog."default",
    "Price" numeric,
    "Quantity" integer,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Category_Id" character varying COLLATE pg_catalog."default",
    "Item_Id" character varying COLLATE pg_catalog."default",
    "Item_Variation_Id" character varying COLLATE pg_catalog."default",
    "Item_Url" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_order_item PRIMARY KEY ("Order_Item_Id"),
    CONSTRAINT order_item_fk_poll_info FOREIGN KEY ("Poll_Info_Id")
        REFERENCES public."Poll_Info" ("Poll_Info_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Order_Item"
    ON public."Order_Item" USING btree
    ("Order_Item_Id" ASC NULLS LAST)
    TABLESPACE pg_default;