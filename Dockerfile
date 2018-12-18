FROM python:3.7     
ADD . /todo
WORKDIR /todo
EXPOSE 80
RUN pip install -r requirements.txt
ENTRYPOINT ["python", "main.py"]
ENV GOOGLE_APPLICATION_CREDENTIALS="gcs.json"