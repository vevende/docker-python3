# docker-python3

	docker pull vevende/python3:latest

Create a Dockerfile

	FROM vevende/python:latest
    COPY requirements.txt /requirements.txt
    RUN gosu app pip install --no-cache-dir -r /requirements.txt
	COPY . /app
    EXPOSE 8000
	CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

## Extending

If you would like to do additional initialization in an image derived from this one, add one or more *.py or *.sh scripts under /docker-entrypoint.d/.

Just before the main entrypoint runs the CMD command, it will run any *.py files and source any *.sh scripts found in that directory.

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
 - The python environment is on `/python`. Useful if you want to mount it as a volume
