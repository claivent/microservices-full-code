kubectl exec -it mongo-db-54b56f9667-k8wrw -- mongosh "mongodb://alibou:alibou@localhost:27017/admin"  
use customer  
db.test.insertOne({name: "test"})

use admin    
db.grantRolesToUser("alibou", [{ role: "readWrite", db: "customer" }])