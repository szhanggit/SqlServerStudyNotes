CREATE TABLE [tpc].[tb_r_response] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [order_id]     INT           NOT NULL,
    [status_code]  VARCHAR (50)  NOT NULL,
    [message]      VARCHAR (MAX) NOT NULL,
    [message_type] VARCHAR (50)  NOT NULL,
    [created_on]   DATETIME      DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_tb_r_response] PRIMARY KEY CLUSTERED ([id] ASC)
);

