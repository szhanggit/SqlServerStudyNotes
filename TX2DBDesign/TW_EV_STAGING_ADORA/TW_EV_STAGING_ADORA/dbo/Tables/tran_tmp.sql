CREATE TABLE [dbo].[tran_tmp] (
    [Id]            INT          IDENTITY (1, 1) NOT NULL,
    [AccountNumber] VARCHAR (50) NULL,
    [ProgramCode]   VARCHAR (50) NULL
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20181204-190219]
    ON [dbo].[tran_tmp]([Id] ASC);

