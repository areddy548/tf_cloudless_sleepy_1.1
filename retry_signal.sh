export http_proxy=172.16.3.98:3128
export https_proxy=172.16.3.98:3128
status=not_completed
while [ $status == completed ]
do
output = $(curl -X GET 'https://signal-app.vtrc0zfo5qo.us-south.codeengine.appdomain.cloud/status?key=$key_status')
status = output["janakey2"]
done
unset http_proxy
unset https_proxy