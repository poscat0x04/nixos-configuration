{ pkgs, ... }:

{
  imports = [
    ../../../modules/networking/wireguard-online-check.nix
  ];
  networking = {
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        include "${pkgs.china-ip-list-nft}"

        table inet filter {
          flowtable f {
            hook ingress priority 0
            devices = { ppp0, br-lan, wg0 }
          }

          chain input {
            type filter hook input priority filter; policy accept;

            ct state { established, related } accept comment "Allow established"

            iif br-lan accept
            jump check_wg
            iif ppp0 jump zone_wan_input
          }

          chain check_wg {
          }

          chain zone_wan_input {
            tcp dport 25586 accept comment "Allow hath"
            tcp dport 5432 accept comment "Allow postgres"
            tcp dport 2285 accept comment "Allow mtproto"
            tcp dport 1688 accept comment "Allow vlmcsd"
            tcp dport 5000 accept comment "Allow IRC"
            tcp dport 22 accept comment "Allow ssh"
            tcp dport 8443 accept comment "Allow HTTPS"
            udp dport 68 accept comment "Allow DHCP renew"
            udp dport 48927 accept comment "Allow wireguard"
            tcp dport 51413 accept comment "Allow bittorrent"
            udp dport 51413 accept comment "Allow bittorrent"
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

            iif br-lan accept comment "Allow LAN to anywhere"
            iif wg0 accept comment "Allow Wireguard to anywhere"
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

        table ip transparent_proxy {
          set ipv4_private {
            type ipv4_addr
            flags interval
            elements = {
              0.0.0.0/8,
              10.0.0.0/8,
              127.0.0.0/8,
              169.254.0.0/16,
              172.16.0.0/12,
              192.168.0.0/16,
              224.0.0.0/4,
              240.0.0.0/4
            }
          }

          set cn_ip {
            type ipv4_addr
            flags interval
            elements = $china_ip_list
          }

          chain prerouting {
            type filter hook prerouting priority mangle; policy accept;
            iif ppp0 accept
            jump proxy
          }

          chain proxy {
            jump filter_direct
            ip protocol {tcp} meta mark set 1 tproxy to 127.0.0.1:5768
          }

          chain output {
            type route hook output priority mangle; policy accept;
            jump filter_direct
            ip protocol {tcp} meta mark set 1
          }

          chain filter_direct {
            ip daddr @ipv4_private accept
            ip daddr @cn_ip accept
            ip protocol udp accept
            meta mark {200, 255} accept
            socket cgroupv2 level 3 "system.slice/system-special.slice/system-special-noproxy.slice" accept
          }
        }

        table ip nat {
          set ipv4_private {
            type ipv4_addr
            flags interval
            elements = {
              10.0.0.0/8,
              172.16.0.0/12,
              192.168.0.0/16,
              169.254.0.0/16
            }
          }

          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            oif ppp0 masquerade
          }

          #chain prerouting {
          #  type nat hook prerouting priority dstnat; policy accept;
          #  iif ppp0 accept
          #  jump proxy
          #}

          #chain output {
          #  type nat hook output priority 300; policy accept;
          #  jump proxy
          #}

          chain proxy {
            ip daddr @ipv4_private accept
            ip daddr 101.6.6.6 accept
            meta mark 255 accept
            ip protocol tcp dnat to 127.0.0.1:5768
          }
        }
      '';
    };
  };
}
