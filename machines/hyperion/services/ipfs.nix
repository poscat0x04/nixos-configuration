{ ... }:

{
  services.kubo = {
    enable = true;
    settings = {
      Addresses = {
        API = ["/ip4/10.1.10.3/tcp/5001"];
        Gateway = ["/ip4/10.1.10.3/tcp/8080"];
      };
      API.HTTPHeaders = {
        Access-Control-Allow-Origin = ["http://10.1.10.3:5001" "http://localhost:3000" "http://127.0.0.1:5001" "https://webui.ipfs.io"];
        Access-Control-Allow-Methods = [ "GET" "POST"];
      };
    };
  };
}
