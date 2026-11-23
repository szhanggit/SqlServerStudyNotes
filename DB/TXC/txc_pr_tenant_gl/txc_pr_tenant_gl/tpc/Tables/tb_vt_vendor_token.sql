CREATE TABLE [tpc].[tb_vt_vendor_token] (
    [id]                         BIGINT        IDENTITY (1, 1) NOT NULL,
    [vendor_code]                VARCHAR (100) NOT NULL,
    [vendor_id]                  INT           NOT NULL,
    [token]                      VARCHAR (100) NOT NULL,
    [expiry]                     INT           NOT NULL,
    [expired_time]               DATETIME      NOT NULL,
    [updated_date]               DATETIME      NULL,
    [refresh_token]              VARCHAR (100) NULL,
    [refresh_token_expires_time] DATETIME      NULL,
    CONSTRAINT [PK_tb_vt_vendor_token] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [UK_tb_vt_vendor_token_vendor_code] UNIQUE NONCLUSTERED ([vendor_code] ASC)
);

