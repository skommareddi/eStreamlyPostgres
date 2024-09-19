CREATE TABLE IF NOT EXISTS public."User_Permission_Invitation"
(
    "User_Permission_Invitation_Id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    "Business_Id" bigint NOT NULL,
    "Email" character varying COLLATE pg_catalog."default" NOT NULL,
    "Invited_By_UserId" character varying COLLATE pg_catalog."default" NOT NULL,
    "Is_Invite_Accepted" boolean NOT NULL DEFAULT false,
    "Created_Date" timestamp with time zone NOT NULL,
    "Created_By" character varying COLLATE pg_catalog."default" NOT NULL,
    "Modified_Date" timestamp with time zone,
    "Modified_By" character varying COLLATE pg_catalog."default",
    "Record_Version" numeric NOT NULL DEFAULT 1,
    CONSTRAINT "User_Permission_Invitation_pkey" PRIMARY KEY ("User_Permission_Invitation_Id"),
    CONSTRAINT userpermissioninvitation_fk_businessid FOREIGN KEY ("Business_Id")
        REFERENCES public."Business" ("Business_Id") MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
