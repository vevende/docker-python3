build:
	docker build -t vevende/python3:latest .

test: build
	cd tests/ && docker build -t vevende/python3:sut .
	cd tests/ && docker run --rm vevende/python3:sut run_tests.sh
