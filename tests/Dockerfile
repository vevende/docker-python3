FROM vevende/python3:latest

COPY requirements.txt /requirements.txt
RUN set -eux \
    && env | sort \
    && which python \
    && which pip \
    && gosu app which python \
    && gosu app which pip \
    && ls -al /python \
    && gosu app pip install --no-cache-dir -r /requirements.txt

COPY entrypoint-touchfile.sh /docker-entrypoint.d/entrypoint1.sh
COPY entrypoint-touchfile.sh /docker-entrypoint.d/entrypoint2.sh
COPY entrypoint-touchfile.py /docker-entrypoint.d/entrypoint1.py
COPY entrypoint-touchfile.py /docker-entrypoint.d/entrypoint2.py
COPY entrypoint-touchfile.sh /docker-entrypoint.d/disabled-entrypoint

COPY run_tests.sh /run_tests.sh

CMD ["gosu", "app", "/run_tests.sh"]
