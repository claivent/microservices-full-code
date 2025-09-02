### STEP:
1. modprobe br_netfilter
2. echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
3. echo '1' > /proc/sys/net/ipv4/ip_forward
4. swapoff -a
5. sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
6. apt-get update && apt-get install -y apt-transport-https ca-certificates curl
7. curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
8. echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
9. apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
10. cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
} EOF  
11. mkdir -p /etc/systemd/system/docker.service.d
12. systemctl daemon-reload
13. systemctl restart docker
14. systemctl enable docker
15. curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
16. echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
17. apt-get update
18. apt-get install -y kubelet kubeadm kubectl
19. apt-mark hold kubelet kubeadm kubectl
20. systemctl enable kubelet
21. systemctl start kubelet
22. kubeadm config images pull
23. history -c
24. echo "Host preparation done."
25. echo "You can now proceed to the Kubernetes installation step."
26. echo "Use 'kubeadm init' on the control plane node and 'kubeadm join' on worker nodes."
27. echo "Refer to the official Kubernetes documentation for detailed instructions."
28. echo "Ensure that your network plugin is compatible with your Kubernetes version."
29. echo "Common network plugins include Calico, Flannel, and Weave."
30. echo "After installation, verify the cluster status using 'kubectl get nodes' and 'kubectl get pods --all-namespaces'."
31. echo "Remember to configure your kubeconfig file to interact with the cluster."
32. echo "You can find the kubeconfig file at /etc/kubernetes/admin.conf on the control plane node."
33. echo "Copy it to your home directory and set the KUBECONFIG environment variable."
34. echo "For example: export KUBECONFIG=$HOME/.kube/config"
35. echo "Happy Kubernetes managing!"
36. # End of host preparation script for Kubernetes installation.
37. # Note: This script assumes a fresh Ubuntu installation and may require adjustments based on your specific environment and requirements.
38. # Always refer to the latest Kubernetes and Docker documentation for best practices and updates.
39. # This script is provided as-is without any warranties. Use at your own risk.
40. # For more advanced configurations, consider setting up a private Docker registry, configuring RBAC in Kubernetes, and implementing monitoring and logging solutions.
41. # Thank you for using this script. Enjoy your Kubernetes journey!
42. # ---
43. # # End of script
44. # ---
45. 