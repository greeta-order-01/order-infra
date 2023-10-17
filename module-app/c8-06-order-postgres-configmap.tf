 # Resource: Config Map
 resource "kubernetes_config_map_v1" "order_postgres_config_map" {
   metadata {
     name = "order-postgres-dbcreation-script"
   }
   data = {
    "order-db.sql" = "${file("${path.module}/order-db.sql")}"
   }
 } 