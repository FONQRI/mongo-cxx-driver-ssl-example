all:
	docker build -t hellomongossl .

run-mongod:
	mkdir -p data
	mongod \
		--dbpath data \
		--sslMode requireSSL \
		--sslWeakCertificateValidation \
		--sslPEMKeyFile mongodb.pem \
		--sslCAFile mongodb-cert.crt \
		--port 9017

run-client:
	mongo --host 127.0.0.1 --port 9017 --ssl --sslAllowInvalidCertificates test
