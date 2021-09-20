{ nixosModules, lib, config, pkgs, ... }:

with lib;
let
  cfg = config.networking.tproxy;
  tproxy-script = pkgs.writeScript "nftables-tproxy-rules" ''
    #! ${pkgs.nftables}/bin/nft -f
    include "${pkgs.china-ip-list-nft}"

    add table ip transparent_proxy
    flush table ip transparent_proxy
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
        jump proxy
      }

      chain output {
        type route hook output priority mangle; policy accept;
        jump filter_direct
        ip protocol {tcp, udp} meta mark set 1
      }

      chain proxy {
        jump filter_direct
        ip protocol {tcp, udp} meta mark set 1 tproxy ip to 127.0.0.1:5768
      }

      chain filter_direct {
        ip daddr @ipv4_private accept
        ip daddr @cn_ip accept
        meta mark 255 accept
      }
    }
  '';
in {
  imports = [
    nixosModules.nftables-china-ip-list-updater
  ];

  options = {
    networking.tproxy = {
      enable = mkEnableOption ''
        transparent proxy using nftables
      '';
    };
  };

  config = {
    services.nftables-china-ip-list-updater = {
      enable = true;
      sets = [
        {
          table = "transparent_proxy";
          set = "cn_ip";
        }
      ];
    };

    systemd.services.nftables-tproxy = {
      description = "transpraent proxy using nftables";
      wantedBy = if cfg.enable then [ "multi-user.target" ] else [];
      after = [ "nftables.service" ];
      requires = [ "nftables.service" ];
      reloadIfChanged = true;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = tproxy-script;
        ExecReload = tproxy-script;
        ExecStop = "${pkgs.nftables}/bin/nft delete table ip transparent_proxy";
      };
    };

    systemd.network = if cfg.enable then {
      netdevs = {
        br = {
          netdevConfig = {
            Name = "br";
            Kind = "bridge";
          };
        };
        dummy0 = {
          netdevConfig = {
            Name = "dummy0";
            Kind = "dummy";
          };
        };
      };
      networks = {
        "11-br" = {
          matchConfig.Name = "br";
          networkConfig = {
            DHCPv6PrefixDelegation = true;
          };
          addresses = [
            {
              addressConfig = {
                Address = "192.168.10.1/24";
              };
            }
          ];
          routingPolicyRules = [
            {
              routingPolicyRuleConfig = {
                FirewallMark = 1;
                Table = 100;
                Priority = 100;
              };
            }
          ];
          routes = [
            {
              routeConfig = {
                Destination = "0.0.0.0/0";
                Type = "local";
                Table = 100;
              };
            }
          ];
        };
        "13-bind-br" = {
          matchConfig.Name = "dummy0";
          networkConfig = {
            Bridge = "br";
          };
        };
      };
    } else {};

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
  };
}
