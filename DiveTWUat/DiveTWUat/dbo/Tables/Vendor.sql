CREATE TABLE [dbo].[Vendor] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [ProgramCode]  VARCHAR (20)   NOT NULL,
    [VendorCode]   VARCHAR (50)   NOT NULL,
    [Name]         NVARCHAR (200) NULL,
    [CallSetting]  NVARCHAR (MAX) NULL,
    [AssemblyCode] VARCHAR (50)   NULL,
    [Status]       TINYINT        CONSTRAINT [DF__Vendor__Status__24927208] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Vendor_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_Vendor_VendorCode] UNIQUE NONCLUSTERED ([ProgramCode] ASC, [VendorCode] ASC)
);

