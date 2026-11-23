CREATE TABLE [dbo].[tb_l_languages] (
    [language_id] INT            IDENTITY (1, 1) NOT NULL,
    [language]    NVARCHAR (128) NOT NULL,
    [is_active]   BIT            NULL,
    PRIMARY KEY CLUSTERED ([language_id] ASC)
);

