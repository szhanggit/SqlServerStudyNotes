CREATE TABLE [dbo].[tb_aom_api_operation_mapping] (
    [aom_id]       INT            IDENTITY (1, 1) NOT NULL,
    [api_info_id]  INT            NOT NULL,
    [operation_Id] INT            NOT NULL,
    [description]  NVARCHAR (250) NULL,
    CONSTRAINT [PK_tb_aom_api_operation_mapping] PRIMARY KEY CLUSTERED ([aom_id] ASC),
    CONSTRAINT [FK_tb_aom_api_operation_mapping_tb_aai_api_action_info] FOREIGN KEY ([api_info_id]) REFERENCES [dbo].[tb_aai_api_action_info] ([api_info_id]),
    CONSTRAINT [FK_tb_aom_api_operation_mapping_tb_o_operation] FOREIGN KEY ([operation_Id]) REFERENCES [dbo].[tb_o_operation] ([operation_id])
);

