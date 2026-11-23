CREATE TYPE [product].[ProductTemplateTags] AS TABLE (
    [tag_id]     INT           NOT NULL,
    [value]      VARCHAR (MAX) NULL,
    [text_value] VARCHAR (MAX) NULL);

