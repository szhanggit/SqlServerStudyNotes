CREATE TABLE [dbo].[tb_pr_program_route] (
    [id]                      INT            IDENTITY (1, 1) NOT NULL,
    [program_code]            NVARCHAR (255) NOT NULL,
    [program_collection_code] NVARCHAR (255) NOT NULL,
    [tenant_id]               INT            NULL,
    CONSTRAINT [PK_PROGRAM_ROUTE] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK_PROGRAMROUTE_REF_TENANT] FOREIGN KEY ([tenant_id]) REFERENCES [dbo].[tb_tbi_tenant_basic_information] ([tenant_basic_info_id])
);

