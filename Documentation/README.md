# Design 
![Design](https://raw.githubusercontent.com/stevenfoong/kubernetes-assignment/main/Documentation/Infra%20Design%2001.png)

# Initial Set Up

# Scale up

## Add new node into K8S

## Add additional wordpress instance replica

# Future Growth
This design will be able to scale horizontal. 
- Cloudflare will be able to improve performance for worldwide coverage
- Nginx can be replace by the Google Load Balance
- Add additional node into K8S cluster will enable the cluster to handle more request
- Database can replicate to other zone for HA and better performance or even convert to Google DB which able to provide multiple instance concurrent read write.

![Design](https://raw.githubusercontent.com/stevenfoong/kubernetes-assignment/main/Documentation/Infra%20Design%2002.png)
