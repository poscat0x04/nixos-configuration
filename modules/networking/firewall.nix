{ ... }:
{
  networking = {
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority filter; policy drop;

            ct state { established, related } accept comment "Allow established"
            ct state invalid drop comment "Drop invalid packets"

            iif lo accept comment "Allow input from loopback"

            tcp dport 22 accept comment "Allow ssh"

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

            meta l4proto tcp reject with tcp reset
            reject with icmpx type port-unreachable
          }

          chain forward {
            type filter hook forward priority filter; policy drop;
          }

          chain output {
            type filter hook output priority filter; policy accept;
          }

          chain log_reject {
            meta pkttype != unicast jump custom_reject
            log prefix "refused packet: " jump custom_reject
          }

          chain custom_reject {
            meta l4proto tcp reject with tcp reset
            reject with icmpx type port-unreachable
          }
        }
      '';
    };
  };
}
