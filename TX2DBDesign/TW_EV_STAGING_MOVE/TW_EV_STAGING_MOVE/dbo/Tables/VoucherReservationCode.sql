CREATE TABLE [dbo].[VoucherReservationCode] (
    [Id]              INT            IDENTITY (1, 1) NOT FOR REPLICATION NOT NULL,
    [ReservationCode] VARCHAR (20)   NOT NULL,
    [Description]     NVARCHAR (500) NULL,
    [CreatedOn]       DATETIME       NOT NULL,
    [CreatedBy]       NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_VoucherReservationCode_Id] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UK_VoucherReservationCode_ReservationCode] UNIQUE NONCLUSTERED ([ReservationCode] ASC)
);

