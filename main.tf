terraform {
    required_providers {
        fortimanager = {
            source = "fortinetdev/fortimanager
        }
    }
}

provider "fortimanager" {
    hostname   = "xxx"
    insecure   = "true"
    username   = "xxx"
    password   = "yyy"
    scopetype  = "adom"
    adom       = "MYADOM"
    lgosession = "true"
    presession = ""
}

resource "fortimanager_exec_workspace_action" "lockers" { # lock root ADOM
  scopetype      = "inherit"
  action         = "lockbegin"
  target         = ""
  param          = "root"
  force_recreate = uuid()
  comment        = ""
}

resource "fortimanager_object_firewall_address" "consul_service" {
    for_each = var.services
    scopetype = "inherit"
    name       = substr("${each.value.id}"", 0 , 70)  # My services registered  from Nomad so it has long name and fortimanager only accept 80 chars
    obj_type   = "ip"
    type       = "ipmask"
    subnet     = [each.value.address, "255.255.255.255"]
    comment    = "synced by git"
    depends_on = [fortimanager_exec_workspace_action.lockers]
}

resource "fortimanager_object_firewall_addrgrp" "external_group" {
    name = "external_services"
    member = flatten([for id, s in var.services : contains(s.tags, "external") ?
                [lookup(fortimanager_object_firewall_address.consul_service, id, "none")] : {"none"}
                ])
}

resource "fortimanager_object_firewall_addrgrp" "tgw_group" {
    name = "external_services"
    member = flatten([for id, s in var.services : contains(s.tags, "terminating-gateway") ?
                [lookup(fortimanager_object_firewall_address.consul_service, id, "none")] : {"none"}
                ])
}

resource "fortimanager_object_firewall_service_custom" "custom_service" {
    for_each = local.external_services
    name = "${each.value[0].name}-service"
    protocol = "TCP/UDP/SCTP"
    iprange  = fortimanager_object_firewall_address.consul_service[each.key].subnet[0]
    tcp_portrange = ["${each.value[0].port}"]
    comment = "I want to set explicit dependency so i added iprage like above"
}

resource "fortimanager_packages_firewall_policy" "package_policy" {
    name = "Allow-postgres"
    action = "accept"
    srcintf = ["any"]
    dstintf = ["any"]
    srcaddr = [fortimanager_object_firewall_addrgrp.tgw_group.name]
    dstaddr = [fortimanager_object_firewall_addrgrp.external_group.name]
    service = length(keys(fortimanager_object_firewall_service_custom.custom_service)) > 0 ? [for k, v in fortimanager_object_firewall_service_custom.custom_service : v.name] : ["NONE"]
    comments = "CTS-Terraform"
    schedule = "always"
    pkg  = "MYPACKAGE"
    lifecycle {
        create_before_destroy = true
    }
}

resource "fortimanager_securityconsole_install_package" "trname" {
    for_each = local.install_package
    fmgadom = var.adom
    force_recreate = uuid()
    flags = ["none"]
    pkg = "MYPACKAGE"

    scope {
        name = "device"
        vdom = "device1"
    }
    depends_on = [fortimanager_packages_firewall_policy.package_policy]
}

resource "fortimanager_exec_workspace_action" "unlockers" { # save change and unlock root ADOM
  scopetype      = "inherit"
  action         = "lockend"
  target         = ""
  param          = "root"
  force_recreate = uuid()
  comment        = ""
  depends_on     = [fortimanager_securityconsole_install_package.trname]

}
