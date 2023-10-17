 # Resource: Config Map
 resource "kubernetes_config_map_v1" "keycloak_postgres_config_map" {
   metadata {
     name = "keycloak-postgres-dbcreation-script"
   }
   data = {
    "keycloak-db.sql" = "${file("${path.module}/keycloak-db.sql")}"
   }
 } 