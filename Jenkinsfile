pipeline {
  agent any
  stages {
    stage('Build') {
      agent {
        node {
          label 'gcp-builder'
        }

      }
      steps {
        sh '''
            #!/bin/bash
            pwd
            ls -alh
            sleep 60
            sudo apt update
            sudo apt install -y python-dev build-essential python3-pip python-pip
            sudo pip3 install virtualenv'''
        sleep 10
        withPythonEnv(pythonInstallation: 'python3') {
          sh '''
                pip install --upgrade pip
                pip install -r requirements.txt
                pip install -r requirements-dev.txt
                pip install nose nosexcover pytest mock retrying
                python -m pytest --junitxml=coverage.xml
                '''
        }

        catchError() {
          echo 'Build Failed'
          emailext(subject: '$DEFAULT_SUBJECT', body: '$PROJECT_NAME - Build # $BUILD_NUMBER - $BUILD_STATUS.<br/> <br/> Check console <a href="$BUILD_URL">output</a> to view full results.<br/> If you cannot connect to the build server, check the attached logs.<br/> <br/> --<br/> Following is the last 100 lines of the log.<br/> <br/> --LOG-BEGIN--<br/> <pre style=\'line-height: 22px; display: block; color: #333; font-family: Monaco,Menlo,Consolas,"Courier New",monospace; padding: 10.5px; margin: 0 0 11px; font-size: 13px; word-break: break-all; word-wrap: break-word; white-space: pre-wrap; background-color: #f5f5f5; border: 1px solid #ccc; border: 1px solid rgba(0,0,0,.15); -webkit-border-radius: 4px; -moz-border-radius: 4px; border-radius: 4px;\'> ${BUILD_LOG, maxLines=100, escapeHtml=true} </pre> --LOG-END--', to: 'alimahamed1996@gmail.com')
        }

        junit '*.xml'
      }
    }
    stage('Dockerise') {
      agent {
        node {
          label 'gcp-builder'
        }

      }
      steps {
        sh '''# Pack docker image
            docker ps
            ls -alh
            /snap/bin/gsutil cp gs://upo-scripts/gcs.json .
            cat gcs.json | docker login -u _json_key --password-stdin https://eu.gcr.io
            ls -alh
            docker build -t ${dockerImage}:Build-$BUILD_NUMBER .
            echo
            docker images
            echo
            sleep 5
            docker push ${dockerImage}:Build-$BUILD_NUMBER'''
      }
    }
    stage('Deploy') {
      agent {
        node {
          label 'master'
        }

      }
      steps {
        input 'Do you want to deploy this to GCP?'
        sh '''gcloud compute instances create-with-container ${instanceName}-${BUILD_NUMBER} \\
            --container-image ${dockerImage}:Build-$BUILD_NUMBER \\
            --network upo \\
            --machine-type f1-micro \\
            --subnet public \\
            --tags public \\
            --network-tier=PREMIUM \\
            --zone europe-west2-b 
            echo \'Go to PORT 80 on this server\'
           '''
        emailext(to: 'alimahamed1996@gmail.com', body: '${SCRIPT, template="groovy_html.template"} <br/> --LOG-BEGIN--<br/> <br/> <pre style=\'line-height: 22px; display: block; color: #333; font-family: Monaco,Menlo,Consolas,"Courier New",monospace; padding: 10.5px; margin: 0 0 11px; font-size: 13px; word-break: break-all; word-wrap: break-word; white-space: pre-wrap; background-color: #f5f5f5; border: 1px solid #ccc; border: 1px solid rgba(0,0,0,.15); -webkit-border-radius: 4px; -moz-border-radius: 4px; border-radius: 4px;\'> ${BUILD_LOG, maxLines=1000, escapeHtml=true} </pre> --LOG-END--', attachLog: true, subject: '$DEFAULT_SUBJECT', replyTo: '$DEFAULT_REPLYTO')
        cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true)
      }
    }
  }
  environment {
    dockerImage = 'eu.gcr.io/upodroid/foozoo'
    instanceName = 'foozoo-build'
  }
}