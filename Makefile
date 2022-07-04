
build-web:
	docker build . --file Dockerfile --tag ch4rli3b.cu.de/store-compare:1.0.0

run-web:
	 docker-compose up -d