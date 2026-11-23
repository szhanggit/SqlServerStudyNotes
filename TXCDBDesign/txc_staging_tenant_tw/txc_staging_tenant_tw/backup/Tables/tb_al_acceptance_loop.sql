CREATE TABLE [backup].[tb_al_acceptance_loop] (
    [acceptance_loop_id] INT            IDENTITY (1, 1) NOT NULL,
    [code]               NVARCHAR (550) NULL,
    [description]        NVARCHAR (100) NULL,
    [status]             BIT            NOT NULL,
    [created_by]         NVARCHAR (250) NOT NULL,
    [created_on]         DATETIME       NOT NULL,
    [last_updated_by]    NVARCHAR (250) NULL,
    [last_updated_on]    DATETIME       NULL,
    [is_default]         BIT            NOT NULL,
    [merchant_group_id]  INT            NULL
);

