CREATE OR REPLACE NOTIFICATION INTEGRATION DATALAKE_NOTIFICATION_INT
  ENABLED = true
  TYPE = QUEUE
  NOTIFICATION_PROVIDER = AZURE_STORAGE_QUEUE
  AZURE_STORAGE_QUEUE_PRIMARY_URI = 'https://devweudatalakestor01.queue.core.windows.net/snowflakedataqueue'
  AZURE_TENANT_ID = 'cb3acb2c-b0a7-404f-aae1-47ade08aa5e1';