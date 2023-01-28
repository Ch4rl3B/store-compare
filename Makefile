
build-web:
	docker build . --file Dockerfile --tag ch4rli3b.cu.de/store-compare:1.0.0

run-web:
	 docker-compose up -d

flutter_test:
	flutter test --no-pub --coverage && \
	lcov --remove coverage/lcov.info 'lib/generated/*' 'lib/generated/l10n/*' 'lib/main.dart' '**/categories.dart' -o coverage/clean_lcov.info

generate_coverage:
	genhtml coverage/clean_lcov.info -o coverage/html

show_coverage: flutter_test generate_coverage
	open coverage/html/index.html