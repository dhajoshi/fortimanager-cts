services = {
 "_nomad-task-1212-1212-211-21-2-1-21-group-egw-egw-connect-terminating-egw.default.eu-dc1" = {
   id = "_nomad-task-1212-1212-211-21-2-1-21-group-egw-egw-connect-terminating-egw"
   name = "egw"
   kind = "terminating-gateway"
   address = "192.168.1.15"
   port = 30203
   meta = {
     external-source = "nomad"
   }
   tags = ["terminating-gateway"]
   namespace = "default"
   status = "passing"
   node = "node1.example.com"
   node_id = "123132-4324324-43242"
   node_address = "192.168.1.15"
   node_datacenter = "eu"
   node_tagged_addresses = {
     lan = "192.168.1.15"
    lan_ipv4 = "192.168.1.15"
    wan = "192.168.1.15"
    wan_ipv4 = "192.168.1.15"
}
node_meta = {
  consul-network-segment = ""
  consul-version = "1.20.1"
}
cts_user_defined_meta = {}
},
 "_nomad-task-354-1254353412-5435211-21-2-1-534521-group-egw-egw-connect-terminating-egw.node2.example.default.eu-dc1" = {
   id = "_nomad-task-1212-1212-211-21-2-1-21-group-egw-egw-connect-terminating-egw"
   name = "egw"
   kind = "terminating-gateway"
   address = "192.168.1.16"
   port = 25244
   meta = {
     external-source = "nomad"
   }
   tags = ["terminating-gateway"]
   namespace = "default"
   status = "passing"
   node = "node2.example.com"
   node_id = "123132-4324324-43242"
   node_address = "192.168.1.15"
   node_datacenter = "eu"
   node_tagged_addresses = {
     lan = "192.168.1.16"
    lan_ipv4 = "192.168.1.16"
    wan = "192.168.1.16"
    wan_ipv4 = "192.168.1.16"
}
node_meta = {
  consul-network-segment = ""
  consul-version = "1.20.1"
}
cts_user_defined_meta = {}
},
"postgres.external_node.default.dc1" = {
  id = "postgres"
  name = "postgres"
  kind = ""
  address = "192.162.5.20"
  port = "5432"
  meta = {}
  tags = ["external"]
  namespace = "default"
  status = "passing"
  node = "external_node.example.com"
  node_id = "2321321-3432-3432-2423-432432"
  node_address = "192.162.5.20"
     node_datacenter = "eu"
   node_tagged_addresses = {
     lan = "192.162.5.20"
    lan_ipv4 = "192.162.5.20"
    wan = "192.162.5.20"
    wan_ipv4 = "192.162.5.20"
  }
node_meta = {
  consul-network-segment = ""
  consul-version = "1.20.1"
}
cts_user_defined_meta = {}
},
}
