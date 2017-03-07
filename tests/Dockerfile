FROM vevende/python3:latest

COPY run_tests.sh /usr/local/bin/run_tests.sh
COPY docker-entry-extra.sh /docker-entrypoint.d/

CMD ["-", "run_tests.sh"]
