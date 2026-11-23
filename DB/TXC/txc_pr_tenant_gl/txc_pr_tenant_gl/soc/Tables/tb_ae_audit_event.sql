CREATE TABLE [soc].[tb_ae_audit_event] (
    [event_id]      BIGINT          IDENTITY (1, 1) NOT NULL,
    [tenant_id]     INT             NOT NULL,
    [event_type]    INT             NOT NULL,
    [event_name]    NVARCHAR (255)  NOT NULL,
    [event_who]     NVARCHAR (255)  NOT NULL,
    [event_when]    DATETIME        NOT NULL,
    [event_where]   NVARCHAR (255)  NOT NULL,
    [event_keyword] NVARCHAR (255)  NOT NULL,
    [event_content] NVARCHAR (2000) NOT NULL,
    CONSTRAINT [PK_AUDITEVENT_EVENT_ID] PRIMARY KEY CLUSTERED ([event_id] ASC)
);

