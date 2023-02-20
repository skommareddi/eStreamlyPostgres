
CREATE TABLE IF NOT EXISTS public."AspNetUsers"
(
    "Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "UserName" character varying COLLATE pg_catalog."default",
    "NormalizedUserName" character varying COLLATE pg_catalog."default",
    "Email" character varying COLLATE pg_catalog."default",
    "NormalizedEmail" character varying COLLATE pg_catalog."default",
    "EmailConfirmed" boolean NOT NULL,
    "PasswordHash" character varying COLLATE pg_catalog."default",
    "SecurityStamp" character varying COLLATE pg_catalog."default",
    "ConcurrencyStamp" character varying COLLATE pg_catalog."default",
    "PhoneNumber" character varying COLLATE pg_catalog."default",
    "PhoneNumberConfirmed" boolean NOT NULL,
    "TwoFactorEnabled" boolean NOT NULL,
    "LockoutEnd" timestamp with time zone,
    "LockoutEnabled" boolean NOT NULL,
    "AccessFailedCount" integer NOT NULL,
    "ImageUrl" character varying COLLATE pg_catalog."default",
    "ThumbnailImageUrl" character varying COLLATE pg_catalog."default",
    "UserShortName" character varying COLLATE pg_catalog."default",
    "FullName" character varying COLLATE pg_catalog."default",
    "Created_Date" timestamp with time zone,
    "Password_Modified_Date" timestamp with time zone,
    CONSTRAINT pk_aspnetusers PRIMARY KEY ("Id")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "EmailIndex"
    ON public."AspNetUsers" USING btree
    ("NormalizedEmail" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_AspNetUsers"
    ON public."AspNetUsers" USING btree
    ("Id" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "UserNameIndex"
    ON public."AspNetUsers" USING btree
    ("NormalizedUserName" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;