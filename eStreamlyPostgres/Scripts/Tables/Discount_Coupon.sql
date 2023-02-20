
CREATE TABLE IF NOT EXISTS public."Discount_Coupon"
(
    "Discount_Coupon_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Product_Id" bigint,
    "Discount_Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Coupon_Desc" character varying COLLATE pg_catalog."default",
    "Coupon_Code" character varying COLLATE pg_catalog."default" NOT NULL,
    "Discount_Percentage" numeric NOT NULL,
    "Discount_Rate" numeric,
    "Valid_Start_Date" timestamp with time zone NOT NULL,
    "Valid_End_Date" timestamp with time zone NOT NULL,
    "Is_Free_Shipping" boolean DEFAULT false,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Upcoming_Unique_Id" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_discount_coupon PRIMARY KEY ("Discount_Coupon_Id"),
    CONSTRAINT discountcoupon_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT discountcoupon_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Discount_Coupon"
    ON public."Discount_Coupon" USING btree
    ("Discount_Coupon_Id" ASC NULLS LAST)
    TABLESPACE pg_default;