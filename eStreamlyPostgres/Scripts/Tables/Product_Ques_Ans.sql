﻿
CREATE TABLE IF NOT EXISTS public."Product_Ques_Ans"
(
    "Product_Ques_Ans_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Product_Id" bigint NOT NULL,
    "QuesPostedUserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Question" character varying COLLATE pg_catalog."default",
    "Answer" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_product_ques_ans PRIMARY KEY ("Product_Ques_Ans_Id"),
    CONSTRAINT productquesans_fk_productid FOREIGN KEY ("Product_Id")
        REFERENCES public."Product" ("Product_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT productquesans_fk_userid FOREIGN KEY ("QuesPostedUserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_Product_Ques_Ans"
    ON public."Product_Ques_Ans" USING btree
    ("Product_Ques_Ans_Id" ASC NULLS LAST)
    TABLESPACE pg_default;