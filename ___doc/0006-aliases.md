sudo vim ~/.bashrc
source ~/.bashrc


alias cp1='incus exec cp1 -- bash'  
alias cp2='incus exec cp2 -- bash'
alias w1='incus exec w1 -- bash'  
alias w2='incus exec w2 -- bash'  


alias k='kubectl'  
alias kcc='kubectl config current-context'  
alias kctx='kubectl config use-context'  


alias kgp='kubectl get pods'  
alias kgpa='kubectl get pods -A'  
alias kgpaa='kubectl get pods --all-namespaces'  
alias kgd='kubectl get deployments'  
alias kgda='kubectl get deployments --all-namespaces'  
alias kgs='kubectl get services'  
alias kgsa='kubectl get services --all-namespaces'  
alias kgn='kubectl get nodes'  
alias kgna='kubectl get nodes --all-namespaces'  
alias kgc='kubectl get configmaps'  
alias kgca='kubectl get configmaps --all-namespaces'  


alias kgsa='kubectl get storageclasses'  
alias kgsaa='kubectl get storageclasses --all-namespaces'  
alias kgr='kubectl get roles'  
alias kgra='kubectl get roles --all-namespaces'  
alias kgro='kubectl get rolebindings'  
alias kgroa='kubectl get rolebindings --all-namespaces'  
alias kgc='kubectl get clusterroles'  
alias kgca='kubectl get clusterroles --all-namespaces'  
alias kga='kubectl get all'  
alias kgaa='kubectl get all --all-namespaces'  




