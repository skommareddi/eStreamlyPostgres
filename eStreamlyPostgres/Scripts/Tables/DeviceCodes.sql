
CREATE TABLE IF NOT EXISTS public."DeviceCodes"
(
    "UserCode" character varying COLLATE pg_catalog."default" NOT NULL,
    "DeviceCode" character varying COLLATE pg_catalog."default" NOT NULL,
    "SubjectId" character varying COLLATE pg_catalog."default",
    "ClientId" character varying COLLATE pg_catalog."default" NOT NULL,
    "CreationTime" timestamp with time zone NOT NULL,
    "Expiration" timestamp with time zone NOT NULL,
    "Data" character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_devicecodes PRIMARY KEY ("UserCode")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "IX_DeviceCodes_DeviceCode"
    ON public."DeviceCodes" USING btree
    ("DeviceCode" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS "IX_DeviceCodes_Expiration"
    ON public."DeviceCodes" USING btree
    ("Expiration" ASC NULLS LAST)
    TABLESPACE pg_default;


CREATE INDEX IF NOT EXISTS "PK_DeviceCodes"
    ON public."DeviceCodes" USING btree
    ("UserCode" COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;