job "status-page" {
  datacenters = ["dc-aws-1"]
  type = "service"

  group "status-page" {
    count = 3
    network {
      port "http" {
        to = 3000
      }
    }

    service {
      name = "status-page"
      tags = ["urlprefix-/"]
      port = "http"
      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "status-page" {
      driver = "docker"
      config {
        image = "mamos88/status-page"
        ports = ["http"]
      }
      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
