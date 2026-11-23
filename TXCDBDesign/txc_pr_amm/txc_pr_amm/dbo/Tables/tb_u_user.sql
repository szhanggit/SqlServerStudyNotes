CREATE TABLE [dbo].[tb_u_user] (
    [user_id]       INT            IDENTITY (1, 1) NOT NULL,
    [user_name]     NVARCHAR (250) NOT NULL,
    [email]         NVARCHAR (500) NULL,
    [firstname]     NVARCHAR (200) NULL,
    [lastname]      NVARCHAR (200) NULL,
    [creation_time] DATETIME       NULL,
    [check_sum]     NVARCHAR (256) NULL,
    [is_ad_user]    BIT            NOT NULL,
    [user_status]   INT            NOT NULL,
    [oid]           NVARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([user_id] ASC),
    UNIQUE NONCLUSTERED ([user_name] ASC)
);

