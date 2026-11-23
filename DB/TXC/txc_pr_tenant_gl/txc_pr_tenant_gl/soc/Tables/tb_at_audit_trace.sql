CREATE TABLE [soc].[tb_at_audit_trace] (
    [trace_id]   BIGINT          IDENTITY (1, 1) NOT NULL,
    [event_id]   BIGINT          NOT NULL,
    [field_name] NVARCHAR (255)  NOT NULL,
    [old_value]  NVARCHAR (2000) NULL,
    [new_value]  NVARCHAR (2000) NULL,
    CONSTRAINT [PK_AUDITTRACE_TRACE_ID] PRIMARY KEY CLUSTERED ([trace_id] ASC),
    CONSTRAINT [FK_AUDITTRACE_REF_AUDITEVENT] FOREIGN KEY ([event_id]) REFERENCES [soc].[tb_ae_audit_event] ([event_id])
);

