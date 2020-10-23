# app-sample
Template for k8s deployment

## Part 1
### Build app-sample container with build.sh
```bash
## How to run locally
export APP_VERSION=v1000
export MY_FLASK_PORT=9999
./build.sh

# output and docker run
docker run -it --rm -p 8080:${MY_FLASK_PORT} docker.example.com/app-sample:${APP_VERSION}
 * Serving Flask app "app" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:9999/ (Press CTRL+C to quit)
172.17.0.1 - - [22/Oct/2020 06:58:55] "GET / HTTP/1.1" 200 -
```

### Deploy app-sample container with deploy.sh
* Pass parameters over Pipeline env vars, see Jenkinsfile
* helm/app-sample/templates/ingress.yaml - ingress url depends on 'env' type
* helm/app-sample/values.yaml - change everything: port, image, replicaSet, resources
```bash
## How to run locally with helm3
## should be installed: helm, kubectl
## With helm and helm/app-sample/values.yaml possible to redefine any parameters

export APP_VERSION=v1000
export MY_FLASK_PORT=9999
## dev,uat,int,prod
export APP_NAMESPACE=dev
./deploy.sh

# output
+ APP_VERSION=v1000
+ APP_ENVIRONMENT=dev
+ MY_FLASK_PORT=9999
+ '[' -z dev ']'
+ '[' -z v1000 ']'
+ '[' -z 9999 ']'
+ helm version
version.BuildInfo{Version:"v3.1.2", GitCommit:"d878d4d45863e42fd5cff6743294a11d28a9abce", GitTreeState:"clean", GoVersion:"go1.13.8"}
+ [[ '' == \t\r\u\e ]]
+ helm upgrade --install app-sample-v1000 ./helm/app-sample --set-string namespace=dev --namespace dev --set-string image.tag=v1000 --set-string service.internalPort=9999 --set replicaCount=3 --force --wait
Release "app-sample-v1000" does not exist. Installing it now.
NAME: app-sample-v1000
LAST DEPLOYED: Thu Oct 22 15:24:05 2020
NAMESPACE: dev
STATUS: deployed
REVISION: 1
TEST SUITE: None

# Delete
export APP_VERSION=v1000
## dev,uat,int,prod
export APP_NAMESPACE=dev
./delete.sh
# output
+ APP_VERSION=v1000
+ APP_ENVIRONMENT=dev
+ '[' -z dev ']'
+ '[' -z v1000 ']'
+ helm version
version.BuildInfo{Version:"v3.1.2", GitCommit:"d878d4d45863e42fd5cff6743294a11d28a9abce", GitTreeState:"clean", GoVersion:"go1.13.8"}
+ [[ '' == \t\r\u\e ]]
+ helm delete app-sample-v1000 --namespace dev
release "app-sample-v1000" uninstalled
```

## Part 2

### 1 In a few words, describe how you provision cloud infrastructure from scratch
* with God's help and extensive experience [Cloud Architect](https://www.credential.net/fec86316-1dc7-4164-bb44-5c122604e75e?key=84f6ba84e6ead2b393c0d60e1e17054a28987535477b7079c900e60d6904f97b)
* I like to use IaC, GitOps, CICD, Jenkins, pipelines, K8s, ansible, terraform, vault, consul, github, prometheus
* I develop tools if i need it, but it not exist
* Everything automated, no manual work and night shifts


### 2 In a few words, describe how you would create a continuous delivery pipeline
* Ive prepared the skeleton pipeline for build and deploy containers, see `Jenkinsfile`
* See blocks below, base on `when` instruction we can decide if we work with trunk (`master`), branches (`fb-*`), tags, releases.
* Also, nice to have tests in containers and deploy it as K8s jobs, base on tests results we may promote PR to dev, or Release
* We need just to set up Web-hooks and understand what is `gitflow`
* We have made it: [https://github.com/griddynamics/mpl](https://github.com/griddynamics/mpl)

```groovy

when {
    expression {
        params.MODE.contains('deploy')
    }
}

// example with branches
stage('Example Deploy') {
    when {
        expression { BRANCH_NAME ==~ /(production|staging)/ }
        anyOf {
            environment name: 'DEPLOY_TO', value: 'production'
            environment name: 'DEPLOY_TO', value: 'int'
        }
    }
    steps {
        echo 'Deploying'
    }
```
