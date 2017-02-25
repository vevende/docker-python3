# docker-python3


	docker pull vevende/python3:latest

Create a Dockerfile

	FROM vevende/python:latest

	COPY requirements.txt /requirements.txt
	COPY webapp.py /app/webapp.py

	CMD ["python", "/app/webapp.py"]


Notes:

 - Place your python app in /app, and copy your requirements to /requirements.txt
 - Library requirements for compiling uWSGI, Pillow and other common python
 modules are already installed
 - The user `app` is meant to run all python applications
 - Is used a virtual environment in `/python`. Useful if you want to mount that
   path as a volume
 - The entrypoint will make sure `/app` and `/python` is owned by `app`
 - The docker entrypoint will update the requirements and install /app if it's 
 a python module, on every run.
 - Is registered a function `update-python-env` that will run install the requirements.txt file if it exists, will install /app/ as a python module 
 if it exists `/app/setup.py`
