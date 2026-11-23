CREATE TABLE [redemption].[tb_rc_response_code] (
    [id]                   SMALLINT       NOT NULL,
    [response_name]        NVARCHAR (50)  NOT NULL,
    [response_description] NVARCHAR (250) NOT NULL,
    CONSTRAINT [PK_tb_rc_response_code] PRIMARY KEY CLUSTERED ([id] ASC)
);

