CREATE TABLE [dbo].[MultipleSelectionMapping] (
    [ID]              BIGINT   IDENTITY (1, 1) NOT NULL,
    [IsNative]        BIT      NOT NULL,
    [MasterVoucherId] BIGINT   NOT NULL,
    [ChildVoucherId]  BIGINT   NOT NULL,
    [Status]          BIT      NOT NULL,
    [ComboDate]       INT      NOT NULL,
    [ComboDateTime]   DATETIME NOT NULL,
    [CreateOn]        DATETIME CONSTRAINT [DF_MultipleSelectionMapping_CreateOn] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_MultipleSelectionMapping] PRIMARY KEY CLUSTERED ([MasterVoucherId] ASC, [ChildVoucherId] ASC)
);

