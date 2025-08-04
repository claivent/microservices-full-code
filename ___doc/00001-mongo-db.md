kubectl exec -it mongo-db-54b56f9667-k8wrw -- mongosh "mongodb://alibou:alibou@localhost:27017/admin"  
use customer  
db.test.insertOne({name: "test"})

use admin    
db.grantRolesToUser("alibou", [{ role: "readWrite", db: "customer" }])

use notification
db.test.insertOne({name: "test"})
db.grantRolesToUser("alibou", [{ role: "readWrite", db: "notification" }])


notification
customer



kubectl exec -it mongo-db-54b56f9667-k8wrw -- mongosh "mongodb://alibou:alibou@localhost:27017/admin" --eval 'db.changeUserPassword("alibou", "alibou")'
