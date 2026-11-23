CREATE TABLE [tpc].[tb_v_vendors] (
    [id]               INT            IDENTITY (1, 1) NOT NULL,
    [program_code]     VARCHAR (20)   NOT NULL,
    [vendor_code]      VARCHAR (50)   NOT NULL,
    [name]             NVARCHAR (200) NULL,
    [setting]          NVARCHAR (MAX) NULL,
    [invoke_type]      TINYINT        DEFAULT ((1)) NOT NULL,
    [interval_minutes] TINYINT        DEFAULT ((0)) NOT NULL,
    [maximum_times]    TINYINT        DEFAULT ((0)) NOT NULL,
    [status]           TINYINT        DEFAULT ((1)) NOT NULL,
    [created_on]       DATETIME       DEFAULT (getdate()) NOT NULL,
    [created_by]       NVARCHAR (250) NOT NULL,
    [modified_by]      NVARCHAR (250) NULL,
    [modified_on]      DATETIME       NULL,
    CONSTRAINT [PK_tb_v_vendors] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_tb_v_vendors_vendor_code] UNIQUE NONCLUSTERED ([program_code] ASC, [vendor_code] ASC)
);

