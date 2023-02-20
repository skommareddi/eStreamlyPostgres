
CREATE TABLE IF NOT EXISTS public."AspNetUserTokens"
(
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "LoginProvider" character varying COLLATE pg_catalog."default" NOT NULL,
    "Name" character varying COLLATE pg_catalog."default" NOT NULL,
    "Value" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_aspnetusertokens PRIMARY KEY ("LoginProvider", "Name", "UserId"),
    CONSTRAINT fk_aspnetusertokens_aspnetusers_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "PK_AspNetUserTokens"
    ON public."AspNetUserTokens" USING btree
    ("UserId" COLLATE pg_catalog."default" ASC NULLS LAST, "LoginProvider" COLLATE pg_catalog."default" ASC NULLS LAST, "Name" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;