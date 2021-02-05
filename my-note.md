Create the inventory.gcp.yml with the following content
```
plugin: gcp_compute
projects:
  - <gcp-project-id>
auth_kind: serviceaccount
service_account_file: ansible.json
```
Executing `ansible-inventory --list -i inventory.gcp.yml` will create a list of GCP instances that are ready to be configured using Ansible.



https://rtfm.co.ua/en/kubernetes-persistentvolume-and-persistentvolumeclaim-an-overview-with-examples/#Create_a_PersistentVolumeClaim-2

https://kubernetes.io/docs/concepts/storage/persistent-volumes/

Create storage class
```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```


To show all the running pods
```
kubectl get pods --all-namespaces -o jsonpath="{..image}" |\
tr -s '[[:space:]]' '\n' |\
sort |\
uniq -c
```


https://github.com/IBM/Scalable-WordPress-deployment-on-Kubernetes
https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/
https://kubernetes.io/docs/tasks/run-application/run-replicated-stateful-application/
https://github.com/kubernetes-sigs/kubespray
https://github.com/kubernetes-sigs/kubespray/blob/master/docs/setting-up-your-first-cluster.md#deployments
