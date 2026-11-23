CREATE TABLE [quotation].[tb_sf_service_fee] (
    [id]                     INT             IDENTITY (1, 1) NOT NULL,
    [name]                   NVARCHAR (50)   NOT NULL,
    [description]            NVARCHAR (500)  NOT NULL,
    [comment]                NVARCHAR (1000) NULL,
    [level]                  INT             NOT NULL,
    [calculation_mode]       INT             NULL,
    [calculation_rule]       NVARCHAR (50)   NULL,
    [status]                 INT             NOT NULL,
    [calculation_expression] INT             NOT NULL,
    CONSTRAINT [PK_tb_sf_service_fee] PRIMARY KEY CLUSTERED ([id] ASC)
);

