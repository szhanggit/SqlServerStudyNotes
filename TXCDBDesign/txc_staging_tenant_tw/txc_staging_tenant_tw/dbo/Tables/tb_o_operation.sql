CREATE TABLE [dbo].[tb_o_operation] (
    [operation_id]   INT            IDENTITY (1, 1) NOT NULL,
    [operation_code] NVARCHAR (50)  NOT NULL,
    [operation_name] NVARCHAR (50)  NOT NULL,
    [description]    NVARCHAR (255) NULL,
    [is_enabled]     BIT            NOT NULL,
    [resource_id]    INT            NOT NULL,
    CONSTRAINT [PK_tb_o_operation] PRIMARY KEY CLUSTERED ([operation_id] ASC),
    CONSTRAINT [FK_tb_o_operation_tb_r_resource] FOREIGN KEY ([resource_id]) REFERENCES [dbo].[tb_r_resource] ([resource_id])
);

