FROM debian:jessie

EXPOSE 8000
CMD ["./bin/run-prod.sh"]

RUN adduser --uid 1000 --disabled-password --gecos '' --no-create-home webdev

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential python python-dev python-pip \
                                               libpq-dev postgresql-client gettext && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# First copy requirements.txt and peep so we can take advantage of
# docker caching.
COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY . /app
RUN DEBUG=False DJANGO_SECRET_KEY=foo ALLOWED_HOSTS=localhost, DATABASE_URL= ./manage.py collectstatic --noinput -c
#RUN chown webdev.webdev -R .
#USER webdev
