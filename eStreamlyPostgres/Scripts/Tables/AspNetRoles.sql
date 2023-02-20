
CREATE TABLE IF NOT EXISTS public."AspNetRoles"
(
    "Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Name" character varying COLLATE pg_catalog."default",
    "NormalizedName" character varying COLLATE pg_catalog."default",
    "ConcurrencyStamp" character varying COLLATE pg_catalog."default",
    CONSTRAINT pk_aspnetroles PRIMARY KEY ("Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_AspNetRoles"
    ON public."AspNetRoles" USING btree
    ("Id" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "RoleNameIndex"
    ON public."AspNetRoles" USING btree
    ("NormalizedName" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;