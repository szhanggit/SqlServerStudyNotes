CREATE TABLE [media].[tb_m_media] (
    [media_id]          INT            IDENTITY (1, 1) NOT NULL,
    [file_name]         VARCHAR (100)  NOT NULL,
    [file_content_type] VARCHAR (255)  NULL,
    [node_url]          VARCHAR (MAX)  NULL,
    [account]           VARCHAR (250)  NULL,
    [blob_name]         VARCHAR (250)  NULL,
    [type]              INT            NOT NULL,
    [width]             VARCHAR (7)    NULL,
    [height]            VARCHAR (7)    NULL,
    [keyword]           NVARCHAR (250) NULL,
    [timestamp]         ROWVERSION     NOT NULL,
    PRIMARY KEY CLUSTERED ([media_id] ASC)
);

