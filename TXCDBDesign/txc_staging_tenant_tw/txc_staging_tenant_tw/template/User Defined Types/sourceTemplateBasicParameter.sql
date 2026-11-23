CREATE TYPE [template].[sourceTemplateBasicParameter] AS TABLE (
    [template_Id]      INT            NULL,
    [template_name]    NVARCHAR (100) NULL,
    [type]             INT            NULL,
    [sub_type]         INT            NULL,
    [status]           TINYINT        NULL,
    [default_language] INT            NULL);

