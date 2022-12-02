export http_proxy=172.16.3.98:3128
export https_proxy=172.16.3.98:3128
curl -X POST https://signal-app.vtrc0zfo5qo.us-south.codeengine.appdomain.cloud/status \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '{
$key_status:"completed"
}'
unset http_proxy
unset https_proxy