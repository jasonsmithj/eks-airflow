[webserver]
authenticate = True
auth_backend = airflow.contrib.auth.backends.google_auth

[google]
client_id = ${GOOGLE_CLIENT_ID}
client_secret = ${GOOGLE_CLIENT_SECRET}
oauth_callback_route = /oauth2callback
domain = <your domain>

[core]
remote_logging = True
remote_base_log_folder = gs://<your gcs bucket>/airflow/logs
remote_log_conn_id = <your log connect id>
