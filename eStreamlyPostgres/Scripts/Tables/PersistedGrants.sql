
CREATE TABLE IF NOT EXISTS public."PersistedGrants"
(
    "Key" character varying COLLATE pg_catalog."default" NOT NULL,
    "Type" character varying COLLATE pg_catalog."default" NOT NULL,
    "SubjectId" character varying COLLATE pg_catalog."default",
    "ClientId" character varying COLLATE pg_catalog."default" NOT NULL,
    "CreationTime" timestamp with time zone NOT NULL,
    "Expiration" timestamp with time zone,
    "Data" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_persistedgrants PRIMARY KEY ("Key")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "IX_PersistedGrants_Expiration"
    ON public."PersistedGrants" USING btree
    ("Expiration" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "IX_PersistedGrants_SubjectId_ClientId_Type"
    ON public."PersistedGrants" USING btree
    ("SubjectId" COLLATE pg_catalog."default" ASC NULLS LAST, "ClientId" COLLATE pg_catalog."default" ASC NULLS LAST, "Type" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "PK_PersistedGrants"
    ON public."PersistedGrants" USING btree
    ("Key" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;