
CREATE TABLE IF NOT EXISTS public."AspNetUserClaims"
(
    "Id" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "ClaimType" character varying COLLATE pg_catalog."default",
    "ClaimValue" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_aspnetuserclaims PRIMARY KEY ("Id"),
    CONSTRAINT fk_aspnetuserclaims_aspnetusers_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "IX_AspNetUserClaims_UserId"
    ON public."AspNetUserClaims" USING btree
    ("UserId" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "PK_AspNetUserClaims"
    ON public."AspNetUserClaims" USING btree
    ("Id" ASC NULLS LAST)
    TABLESPACE pg_default;