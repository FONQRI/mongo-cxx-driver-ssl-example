all:
	docker build -t hellomongossl .

run-mongod:
	mongod --dbpath data --sslMode requireSSL --sslPEMKeyFile mongodb.pem --sslCAFile mongodb-cert.crt --port 9017
