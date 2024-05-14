# Example use of endpointmonitor_proxy_hosts to setup
# checks on each to check each is working.

data "endpointmonitor_proxy_hosts" "example" {
  search = "proxy"
}

data "endpointmonitor_check_host" "controller" {
  search = "controller"
}

data "endpointmonitor_check_group" "health" {
  search = "Health Checks"
}

resource "endpointmonitor_url_check" "example" {
  count = length(data.endpointmonitor_proxy_hosts.example)

  name                   = "Proxy Health Check"
  description            = "Checks URL is reachable through proxy"
  check_frequency        = 60
  url                    = "https://www.mycompany.com/"
  trigger_count          = 2
  request_method         = "GET"
  expected_response_code = 200
  alert_response_time    = 5000
  warning_response_time  = 3000
  timeout                = 10000
  allow_redirects        = false

  request_header {
    name  = "User-Agent"
    value = "EndPoint Monitor"
  }

  check_host_id  = data.endpointmonitor_check_host.controller.id
  check_group_id = data.endpointmonitor_check_group.health.id
  proxy_host_id  = data.endpointmonitor_proxy_hosts.example.ids[count.index]
}