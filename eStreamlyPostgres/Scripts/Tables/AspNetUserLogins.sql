
CREATE TABLE IF NOT EXISTS public."AspNetUserLogins"
(
    "LoginProvider" character varying COLLATE pg_catalog."default" NOT NULL,
    "ProviderKey" character varying COLLATE pg_catalog."default" NOT NULL,
    "ProviderDisplayName" character varying COLLATE pg_catalog."default",
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_aspnetuserlogins PRIMARY KEY ("LoginProvider", "ProviderKey"),
    CONSTRAINT fk_aspnetuserlogins_aspnetusers_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "IX_AspNetUserLogins_UserId"
    ON public."AspNetUserLogins" USING btree
    ("UserId" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "PK_AspNetUserLogins"
    ON public."AspNetUserLogins" USING btree
    ("LoginProvider" COLLATE pg_catalog."default" ASC NULLS LAST, "ProviderKey" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;