CREATE TABLE IF NOT EXISTS public."Shopping_Cart_Video_Mapping"
(
    "Shopping_Cart_Video_Mapping_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Shopping_Cart_Items_Id" bigint NOT NULL,
    "Business_Id" bigint,
    "Media_Unique_Id" character varying COLLATE pg_catalog."default",
    "Quantity" integer NOT NULL,
    "Is_Active" character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'Y'::character varying,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "Shopping_Cart_Video_Mapping_pkey" PRIMARY KEY ("Shopping_Cart_Video_Mapping_Id"),
    CONSTRAINT "Shopping_Cart_Video_Mapping_fk_Business_Id" FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "Shopping_Cart_Video_Mapping_fk_Shopping_Cart_Items_Id" FOREIGN KEY ("Shopping_Cart_Items_Id")
        REFERENCES public."Shopping_Cart_Items" ("Shopping_Cart_Items_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)