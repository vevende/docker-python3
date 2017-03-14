FROM vevende/python3:latest

COPY requirements.txt /requirements.txt

RUN gosu app pip install -r requirements.txt

COPY run_tests.sh /usr/local/bin/run_tests.sh
COPY entrypoint-touchfile.sh /docker-entrypoint.d/post-entrypoint.sh
COPY entrypoint-touchfile.sh /docker-entrypoint.d/pre-entrypoint.sh
COPY entrypoint-touchfile.sh /docker-entrypoint.d/disabled-entrypoint.sh

CMD ["-", "run_tests.sh"]
