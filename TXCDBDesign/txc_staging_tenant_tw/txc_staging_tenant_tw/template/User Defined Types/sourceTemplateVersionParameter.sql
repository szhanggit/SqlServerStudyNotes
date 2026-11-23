CREATE TYPE [template].[sourceTemplateVersionParameter] AS TABLE (
    [template_version_id] INT            NULL,
    [template_Id]         INT            NULL,
    [language_id]         INT            NULL,
    [version]             INT            NULL,
    [is_current_version]  BIT            NULL,
    [description]         NVARCHAR (500) NULL,
    [subject1]            NVARCHAR (500) NULL,
    [content1]            NVARCHAR (MAX) NULL,
    [subject2]            NVARCHAR (500) NULL,
    [content2]            NVARCHAR (MAX) NULL,
    [subject3]            NVARCHAR (500) NULL,
    [content3]            NVARCHAR (MAX) NULL);

