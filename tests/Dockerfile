FROM vevende/python3:latest

COPY requirements.txt /requirements.txt
RUN gosu app pip install -r /requirements.txt

COPY run_tests.sh /usr/local/bin/run_tests.sh
COPY entrypoint-touchfile.sh /docker-entrypoint.d/entrypoint1.sh
COPY entrypoint-touchfile.sh /docker-entrypoint.d/entrypoint2.sh
COPY entrypoint-touchfile.py /docker-entrypoint.d/entrypoint1.py
COPY entrypoint-touchfile.py /docker-entrypoint.d/entrypoint2.py
COPY entrypoint-touchfile.sh /docker-entrypoint.d/disabled-entrypoint

CMD ["-", "run_tests.sh"]
