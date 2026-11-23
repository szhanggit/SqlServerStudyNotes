CREATE COLUMN MASTER KEY [TXCCMK]
WITH (
     KEY_STORE_PROVIDER_NAME = N'AZURE_KEY_VAULT',
     KEY_PATH = N'https://esg-aks-kv-d.vault.azure.net/keys/TXCCMK/a46dd5b753944de4bd275db77393dc1f'
);

