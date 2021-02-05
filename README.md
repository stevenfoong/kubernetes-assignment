# Kubernetes Assignment
This is a documentation for one of my interview technical assignment.

### Download all the files from the github
```
git clone https://github.com/stevenfoong/kubernetes-assignment.git
```

### Execute the prepare script to prepare the workstation
```
cd kubernetes-assignment
chmod +x prepare.sh
sudo ./prepare.sh
```

## Retrieve GCP credential

To work with the GCP modules, you’ll first need to get some credentials in the JSON format:
1. [Create a Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
2. [Grant access](https://cloud.google.com/iam/docs/granting-changing-revoking-access)
3. [Download JSON credentials](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)

### Enable GCP API
Enable [**Compute Engine API** and **Cloud SQL Admin API** at the GCP for the project](https://cloud.google.com/endpoints/docs/openapi/enable-api) 

### Enable GCP Module at Ansible

In order to be able to use GCP module in ansiblle, you will need to enable it first by specifying the following in the `/etc/ansible/ansible.cfg` file:
```
[inventory]
enable_plugins = gcp_compute
```

#### Provision nodes
Issue the following command to provision the nodes . Replace the **env** parameter as needed.
```
ansible-playbook --key-file "key" --user ansible --ssh-common-args='-o StrictHostKeyChecking=no' --become --become-user=root -e "env=prod" initial-cluster.yml
```


#### Initial kurbenetes
```
git clone https://github.com/kubernetes-incubator/kubespray.git
cd kubespray
pip install -r requirements.txt
pip3 install -r contrib/inventory_builder/requirements.txt
cp -rfp inventory/sample inventory/prod
declare -a IPS=(10.128.0.17 10.128.0.18 10.128.0.19) # you need to replace the list of IP with the private ip of the vm nodes
CONFIG_FILE=inventory/prod/hosts.yml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```

Modify `inventory/prod/hosts.yml` field `ansible_host` with the node public 

```
ansible-playbook --key-file "key" --user ansible --ssh-common-args='-o StrictHostKeyChecking=no' -i inventory/prod/hosts.yml --become --become-user=root cluster.yml
```
**Ansible will now execute the playbook, this can take up to 20 minutes.**

#### Access the kubernetes cluster

First, we need to edit the permission of the kubeconfig file on one of the controller nodes:

```
ssh $USERNAME@$IP_CONTROLLER_0 **Remember to replace the USERNAME and IP_CONTROLLER**
USERNAME=$(whoami)
sudo chown -R $USERNAME:$USERNAME /etc/kubernetes/admin.conf
exit
```

Now we will copy over the kubeconfig file:

```
scp $USERNAME@$IP_CONTROLLER_0:/etc/kubernetes/admin.conf kubespray-do.conf
```

Change the server ip address in kubespray-do.conf to public ip address.

Example
```
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: XXX
    server: https://35.205.205.80:6443
  name: cluster.local
...
```

Now, we load the configuration for kubectl:
```
export KUBECONFIG=$PWD/kubespray-do.conf
```
We should be all set to communicate with our cluster from our local workstation:
```
kubectl get nodes
```
Output
```
NAME           STATUS   ROLES                  AGE   VERSION
vm-01          Ready    control-plane,master   47m   v1.20.2
vm-02          Ready    control-plane,master   46m   v1.20.2
vm-03          Ready    <none>                 45m   v1.20.2
```

You can refer to the **SmokeTests.md** to test out the k8s installation

#### Deploy Workpress

```
wget https://raw.githubusercontent.com/stevenfoong/kubernetes-assignment/main/wordpress-deployment.yaml
wget https://raw.githubusercontent.com/stevenfoong/kubernetes-assignment/main/local-volumes.yaml
```

Modify value of `WORDPRESS_DB_HOST` and `WORDPRESS_DB_PASSWORD` in the file `wordpress-deployment.yaml`.

Initial local volume and wordpress service

```
kubectl apply -f local-volumes.yaml
kubectl apply -f wordpress-deployment.yaml
```

Issue command `kubectl get services` to find out the wordpress service port number

```
$ kubectl get services
NAME              TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
wordpress         NodePort    10.233.37.62    <none>        80:30992/TCP   16h
```

#### Setup nginx

Enable http access for the nginx instance at GCP console.

SSH into nginx node
```
wget https://raw.githubusercontent.com/stevenfoong/kubernetes-assignment/main/setup_nginx.sh
chomod +x setup_nginx.sh
```

Modify `/etc/nginx/conf.d/wordpress.conf` .

Value of `server_name` and `server` need to be change accordingly.

Start the Nginx container.
```
docker run -it -d -p 80:80 --name web-lb -v /etc/nginx/conf.d:/etc/nginx/conf.d nginx
```

#### Configure Cloudflare

Steps to configure cloudflare will not cover in document.

#### Test out workpress installation

Now you should be able to access the wordpress through public ip and the domain name configure at cloudflare.

#### Test K8S load balance and HA
