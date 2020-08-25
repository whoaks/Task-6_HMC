provider "kubernetes" {
config_context_cluster = "minikube"
}

resource "kubernetes_deployment" "example" {
  metadata {
    name = "mywp"
  }

spec {
    replicas = 3

    selector {
      match_expressions {
        key = "dc"
        operator = "In"
        values = ["The_wall" , "winterfell"] 

}     
    }


    template {
      metadata {
        labels = {
          dc = "winterfell"
        }
      }

      spec {
        container {
          image = "wordpress:4.8-apache"
          name  = "mywp"
        
           }
      }
    }
  }
}

resource "kubernetes_service" "wplb" {
  metadata {
    name = "mywplb"
  }
  spec {
    selector = {
      app = "wordpress"
    }
    port {
      node_port = 32123
      port = 80
      target_port = 80
    }

    type = "NodePort"
  }
}