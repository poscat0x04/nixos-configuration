#!/usr/bin/env nix-shell
#!nix-shell -i python3 -p nix-prefetch-scripts python3Packages.requests python3Packages.pyyaml

from packaging.version import Version, parse
from requests import post
from yaml import load, dump
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper
import json
import subprocess

def getLatestVersionInfo(publisher, name):
    url = 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery'
    data = { 'assetTypes': None
           , 'filters': [
               { 'criteria': [{'filterType': 7, 'value': '{}.{}'.format(publisher,name)}]
               , 'direction': 2
               , 'pageSize': 100
               , 'pageNumber': 1
               , 'sortBy': 0
               , 'sortOrder': 0
               , 'pagingToken': None
               }
             ]
           , 'flags': 103
           }
    headers = { 'Content-type': 'application/json', 'Accept': 'application/json;api-version=6.1-preview.1;excludeUrls=true' }
    r = post(url, data=json.dumps(data), headers=headers)
    versions = r.json()['results'][0]['extensions'][0]['versions']
    latest_version = sorted(versions, key=lambda x: parse(x['version']), reverse=True)[0]
    ver = latest_version['version']
    files = latest_version['files']
    vsix = list(filter(lambda x: x['assetType'] == 'Microsoft.VisualStudio.Services.VSIXPackage', files))[0]
    url = vsix['source']
    return ver, url

def prefetch_url(url):
    args = ["nix-prefetch-url", url]
    o = subprocess.check_output(args).decode("utf-8")
    return o.strip()

def main():
    with open('overlays/pkgs/vscode/extensions.yaml') as f:
        exts = load(f.read(), Loader=Loader)
        result = []
        for ext in exts:
            name = ext['name']
            publisher = ext['publisher']
            ver, url = getLatestVersionInfo(publisher, name)
            sha256 = prefetch_url(url)
            result.append({ 'name': name, 'publisher': publisher, 'version': ver, 'sha256': sha256 })
        with open('overlays/pkgs/vscode/extensions.json', 'w+') as target:
            json.dump(result, target, indent=4, sort_keys=True)

if __name__ == '__main__':
    main()
