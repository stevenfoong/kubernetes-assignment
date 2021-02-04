### Smoke tests

**Network**

Let's verify if the network layer is properly functioning and pods can reach each other:

Open up one console.
```
kubectl run myshell1 -it --rm --image busybox -- sh
hostname -i
# launch myshell2 in seperate terminal (see next code block) and ping the hostname of myshell2
ping <hostname myshell2>
```
Open up another console.
```
kubectl run myshell2 -it --rm --image busybox -- sh
hostname -i
ping <hostname myshell1>
```

**Deployments**

In this section you will verify the ability to create and manage Deployments.

Create a deployment for the nginx web server:
```
kubectl create deployment nginx --image=nginx
```
List the pod created by the nginx deployment:
```
kubectl get pods -l app=nginx
```
Output
```
NAME                     READY   STATUS    RESTARTS   AGE
nginx-86c57db685-bmtt8   1/1     Running   0          18s
```

**Port Forwarding**

In this section you will verify the ability to access applications remotely using port forwarding.

Retrieve the full name of the nginx pod:

```
POD_NAME=$(kubectl get pods -l app=nginx -o jsonpath="{.items[0].metadata.name}")
```

Forward port 8080 on your local machine to port 80 of the nginx pod:

```
kubectl port-forward $POD_NAME 8080:80
```

Output

```
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
```

In a new terminal make an HTTP request using the forwarding address:

```
curl --head http://127.0.0.1:8080
```

Output

```
HTTP/1.1 200 OK
Server: nginx/1.19.1
Date: Thu, 13 Aug 2020 11:12:04 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 07 Jul 2020 15:52:25 GMT
Connection: keep-alive
ETag: "5f049a39-264"
Accept-Ranges: bytes
```

Switch back to the previous terminal and stop the port forwarding to the `nginx` pod:

```
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
^C
```

**Logs**
In this section you will verify the ability to retrieve container logs.

Print the `nginx` pod logs:

```
kubectl logs $POD_NAME
```

Output

```
...
127.0.0.1 - - [13/Aug/2020:11:12:04 +0000] "HEAD / HTTP/1.1" 200 0 "-" "curl/7.64.1" "-"
```

**Exec**

In this section you will verify the ability to execute commands in a container.

Print the nginx version by executing the `nginx -v` command in the `nginx` container:

```
kubectl exec -ti $POD_NAME -- nginx -v
```

Output

```
nginx version: nginx/1.19.1
```

**Kubernetes services**

**Expose outside of the cluster**

In this section you will verify the ability to expose applications using a Service.

Expose the `nginx` deployment using a NodePort service:

```
kubectl expose deployment nginx --port 80 --type NodePort
```

Retrieve the node port assigned to the nginx service:

```
kubectl get svc nginx
```

** Remember tp create a firewall rule that allows remote access to the nginx node port at GCP console**

Retrieve the external IP address of a worker instance from the GCP console.

Make an HTTP request using the external IP address and the nginx node port:

```
curl -I http://${EXTERNAL_IP}:${NODE_PORT}
```

Output

```
HTTP/1.1 200 OK
Server: nginx/1.19.1
Date: Thu, 13 Aug 2020 11:15:02 GMT
Content-Type: text/html
Content-Length: 612
Last-Modified: Tue, 07 Jul 2020 15:52:25 GMT
Connection: keep-alive
ETag: "5f049a39-264"
Accept-Ranges: bytes
```

**Cleaning Up**

**Kubernetes resources**

Delete the dev namespace, the nginx deployment and service:

```
kubectl delete namespace dev
kubectl delete deployment nginx
kubectl delete svc/ngninx
```
