CREATE TABLE [trans].[tb_trt_transaction_reference_type] (
    [trans_ref_type_id] SMALLINT      NOT NULL,
    [reference_type]    VARCHAR (20)  NOT NULL,
    [reference_id]      VARCHAR (20)  NOT NULL,
    [entity_type]       VARCHAR (255) NOT NULL,
    [entity_id]         VARCHAR (255) NOT NULL,
    UNIQUE NONCLUSTERED ([trans_ref_type_id] ASC)
);

