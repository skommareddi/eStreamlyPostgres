
CREATE TABLE IF NOT EXISTS public."AspNetRoleClaims"
(
    "Id" integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1 ),
    "RoleId" character varying COLLATE pg_catalog."default" NOT NULL,
    "ClaimType" character varying COLLATE pg_catalog."default",
    "ClaimValue" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_aspnetroleclaims PRIMARY KEY ("Id"),
    CONSTRAINT fk_aspnetroleclaims_aspnetroles_roleid FOREIGN KEY ("RoleId")
        REFERENCES public."AspNetRoles" ("Id") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "IX_AspNetRoleClaims_RoleId"
    ON public."AspNetRoleClaims" USING btree
    ("RoleId" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_AspNetRoleClaims"
    ON public."AspNetRoleClaims" USING btree
    ("Id" ASC NULLS LAST)
    TABLESPACE pg_default;