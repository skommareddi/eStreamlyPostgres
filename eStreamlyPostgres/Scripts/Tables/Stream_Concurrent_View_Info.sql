CREATE TABLE IF NOT EXISTS public."Stream_Concurrent_View_Info"
(
    "Stream_Concurrent_View_Info_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Live_Stream_Info_Id" bigint NOT NULL,
    "Concurrent_View_Logged_Date" timestamp with time zone NOT NULL,
    "Unique_Id" character varying COLLATE pg_catalog."default" NOT NULL,
    "Viewer_Count" bigint NOT NULL,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT pk_stream_concurrent_view_info PRIMARY KEY ("Stream_Concurrent_View_Info_Id"),
    CONSTRAINT stream_concurrent_view_info_fk_live_stream_info FOREIGN KEY ("Live_Stream_Info_Id")
        REFERENCES public."Live_Stream_Info" ("Live_Stream_Info_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)