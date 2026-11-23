CREATE SEQUENCE [merchant_info].[seq_merchant_identity_code]
    AS BIGINT
    START WITH 5000
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999999999
    CYCLE;

