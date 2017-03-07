# docker-python3

	docker pull vevende/python3:latest

The image will look for a `requirements.txt` file in the root of your project. And optionally a `setup.py` file.

Create a Dockerfile

	FROM vevende/python:latest
	COPY webapp.py /app/webapp.py
	CMD ["python", "/app/webapp.py"]

## Extending

If you would like to do additional initialization in an image derived from this one, add one or more *.py or *.sh scripts under /docker-entrypoint.d (creating the directory if necessary). After the entrypoint initialize the python environment, it will run any *.py files and source any *.sh scripts found in that directory to do further initialization before starting the service.

For example if you have a Django project, you could run migrations and create a default superuser before the app is running. 

Having /docker-entrypoint.d/00_init-django-project.sh:

    #!/bin/bash
    set -e

    echo -n "Django check project ... "
    python src/manage.py check
    echo "Done"

    echo "Running migrations"
    python src/manage.py migrate --no-input

Having /docker-entrypoint.d/10_create_superuser.py:

    import os
    import django

    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "myproject.settings")
    django.setup()

    from django.contrib.auth import User

    print("Creating superuser... ", end='')

    superuser = User.objects.create_superuser(
        username='admin',
        email='admin@localhost',
        password='admin'
    )

    print("Done")

Notes:

 - Library requirements for compiling uWSGI, Pillow and other common python
 modules are already installed
 - The user `app` is meant to run all python applications
 - Is used a virtual environment in `/python`. Useful if you want to mount that path as a volume
 - The entrypoint will make sure `/app` and `/python` is owned by `app`
 - The docker entrypoint will update the requirements and install /app if it's a python module.
 - Is registered a function `update-python-env` that will run install the requirements.txt file if it exists, will install /app/ as a python module 
 if it exists `/app/setup.py`
