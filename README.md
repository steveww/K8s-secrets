# Using K8s Secrets to Configure the Instana Agent

When deploying the Instana agent as a daemonset in Kubernetes, it is possible to use secrets to manage the agent configuration.

Ideally we could just mount the INSTANA Agent configuration.yaml file directly as a secret. Alas this messes up the Agent and causes a load of exceptions and the agent to restart. My guess is that the mount messes up how the agent tracks changes to file. Instead I mount the secret elsewhere in the filesystem and use my own script *updater.sh* to keep an eye on changes, then copy over the file.

To have a play with this follow these steps:

Build your own agent image.

    $ docker build -t your-repo/agent .

Fire up minikube to get a K8s cluster going

    $ kubectl create namespace instana-agent
    $ ./make-secret.sh
    $ kubectl apply -f secrets.yaml

Edit instana-agent.yml and put in your base64 encoded agent key and image you created above

    $ kubectl create -f instana-agent.yml
    $ kubectl label node minikube agent=instana
    $ kubectl -n instana-agent get pod

Make a note of the pod, it may take a while to get going

    $ kubectl -n instana-agent logs -f <pod>

In a different shell edit the configuration.yaml file and add the following

    com.instana.plugin.statsd:
      enabled: true
      ports:
        udp: 8125
        mgmt: 8126
      flush-interval: 10

Create the secrets file and apply it again

    $ ./make-secret.sh
    $ kubectl apply -f secrets.yaml

Back in the original shell after a few moments you should see notification that the file has changed and the agent is enabling the statsd sensor.

There you have it. Dynamic updates to the agent configuration - QED.