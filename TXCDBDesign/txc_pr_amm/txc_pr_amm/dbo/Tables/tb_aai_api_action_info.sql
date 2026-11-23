CREATE TABLE [dbo].[tb_aai_api_action_info] (
    [api_info_id]     INT            IDENTITY (1, 1) NOT NULL,
    [controller_name] NVARCHAR (250) NOT NULL,
    [action_name]     NVARCHAR (250) NOT NULL,
    [key_value]       NVARCHAR (64)  NOT NULL,
    CONSTRAINT [PK_tb_aai_api_action_info] PRIMARY KEY CLUSTERED ([api_info_id] ASC),
    CONSTRAINT [UC_tb_aai_api_action_info_key_value] UNIQUE NONCLUSTERED ([key_value] ASC)
);

