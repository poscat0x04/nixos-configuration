{ ... }:
{
  networking = {
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          flowtable f {
            hook ingress priority 0
            devices = { ppp0, ens36 }
          }

          chain input {
            type filter hook input priority filter; policy accept;

            ct state { established, related } accept comment "Allow established"

            iif ens36 accept
            iif ppp0 jump zone_wan_input
          }

          chain zone_wan_input {
            tcp dport 22 accept comment "Allow ssh"
            tcp dport 8443 accept comment "Allow HTTPS"
            udp dport 68 accept comment "Allow DHCP renew"
            icmp type echo-request accept comment "Allow ping"

            ip6 saddr fc00::/6 ip6 daddr fc00::/6 udp dport 546 accept comment "Allow DHCPv6"
            ip6 saddr fe80::/10 icmpv6 type {
              mld-listener-query,
              mld-listener-report,
              mld-listener-done,
              mld-listener-reduction,
              mld2-listener-report,
            } accept comment "Allow MLD"
            icmpv6 type {
              echo-request,
              echo-reply,
              destination-unreachable,
              packet-too-big,
              time-exceeded,
              parameter-problem,
              nd-router-solicit,
              nd-router-advert,
              nd-neighbor-solicit,
              nd-neighbor-advert,
            } limit rate 1000/second accept comment "Allow ICMPv6"

            ct status dnat accept comment "Allow port forwards"

            jump custom_reject
          }

          chain forward {
            type filter hook forward priority filter; policy drop;

            meta l4proto { tcp, udp } flow offload @f

            iif ens36 accept comment "Allow LAN to anywhere"
            iif ppp0 jump zone_wan_forward
          }

          chain zone_wan_forward {
            ct state { established, related } accept comment "Allow established"

            icmpv6 type {
              echo-request,
              echo-reply,
              destination-unreachable,
              packet-too-big,
              time-exceeded,
              parameter-problem,
            } limit rate 1000/second accept comment "Allow ICMPv6 Forward"

            meta l4proto esp accept comment "Allow IPSec ESP"
            udp dport 500 accept comment "Allow ISAKMP"
            ct status dnat accept comment "Allow port forwards"

            oif ppp0 jump custom_reject
          }

          chain output {
            type filter hook output priority filter; policy accept;

            oif ppp0 ct state invalid drop;
          }

          # A chain for rejecting packets that accounts for TCP connections
          chain custom_reject {
            meta l4proto tcp reject with tcp reset
            reject with icmpx type port-unreachable
          }
        }

        table inet raw {
          chain forward {
            type filter hook forward priority mangle; policy accept;

            tcp flags syn tcp option maxseg size set rt mtu
          }
        }

        table ip nat {
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            oif ppp0 masquerade
          }
        }
      '';
    };
  };
}
