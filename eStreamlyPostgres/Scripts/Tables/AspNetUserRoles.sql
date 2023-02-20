
CREATE TABLE IF NOT EXISTS public."AspNetUserRoles"
(
    "UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "RoleId" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_aspnetuserroles PRIMARY KEY ("RoleId", "UserId"),
    CONSTRAINT fk_aspnetuserroles_aspnetroles_roleid FOREIGN KEY ("RoleId")
        REFERENCES public."AspNetRoles" ("Id") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT fk_aspnetuserroles_aspnetusers_userid FOREIGN KEY ("UserId")
        REFERENCES public."AspNetUsers" ("Id") MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);

CREATE INDEX IF NOT EXISTS "IX_AspNetUserRoles_RoleId"
    ON public."AspNetUserRoles" USING btree
    ("RoleId" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_AspNetUserRoles"
    ON public."AspNetUserRoles" USING btree
    ("UserId" COLLATE pg_catalog."default" ASC NULLS LAST, "RoleId" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;