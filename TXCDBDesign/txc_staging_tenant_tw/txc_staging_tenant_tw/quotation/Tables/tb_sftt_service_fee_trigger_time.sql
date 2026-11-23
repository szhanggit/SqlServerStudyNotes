CREATE TABLE [quotation].[tb_sftt_service_fee_trigger_time] (
    [id]             INT IDENTITY (1, 1) NOT NULL,
    [service_fee_id] INT NOT NULL,
    [tran_type]      INT NOT NULL,
    [status]         INT NOT NULL,
    CONSTRAINT [PK_tb_sftt_service_fee_trigger_time] PRIMARY KEY CLUSTERED ([id] ASC)
);

