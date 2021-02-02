# Kubernetes Assignment
This is a documentation for one of my interview technical assignment.

## Prepare the workstation.

### Install kubectl
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Generate ssh key
```
ssh-keygen -f key
```

### Install Git
```
sudo dnf install git -y
```

### Install ansible and GCP (Google Cloud Platform) module
```
sudo dnf install ansible -y
pip install requests google-auth
```

To work with the GCP modules, you’ll first need to get some credentials in the JSON format:
1. [Create a Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts)
2. [Grant access](https://cloud.google.com/iam/docs/granting-changing-revoking-access)
3. [Download JSON credentials](https://cloud.google.com/iam/docs/creating-managing-service-account-keys)

### Enable GCE Dynamic Inventory
First, [Enable **Compute Engine API** at the GCP for the project](https://cloud.google.com/endpoints/docs/openapi/enable-api)

To be able to use this GCE dynamic inventory plugin, you need to enable it first by specifying the following in the `/etc/ansible/ansible.cfg` file:
```
[inventory]
enable_plugins = gcp_compute
```
Create the inventory.gcp.yml with the following content
```
plugin: gcp_compute
projects:
  - <gcp-project-id>
auth_kind: serviceaccount
service_account_file: ansible.json
```
Executing `ansible-inventory --list -i inventory.gcp.yml` will create a list of GCP instances that are ready to be configured using Ansible.

#### Provision nodes
Issue the following command to initial the cluster . Replace the env parameter as needed.
```
ansible-playbook --key-file "key" --user ansible --ssh-common-args='-o StrictHostKeyChecking=no' -e "env=test" initial-cluster.yml
```


#### Initial kurbenetes
```
git clone https://github.com/kubernetes-incubator/kubespray.git
cd kubespray
pip install -r requirements.txt
pip3 install -r contrib/inventory_builder/requirements.txt
```


To show all the running pods
```
kubectl get pods --all-namespaces -o jsonpath="{..image}" |\
tr -s '[[:space:]]' '\n' |\
sort |\
uniq -c
```
