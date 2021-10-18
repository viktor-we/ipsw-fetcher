from urllib2 import Request, urlopen
import json

headers = {
  'Accept': 'application/json'
}
request = Request('https://private-anon-5bbe71358a-ipswdownloads.apiary-proxy.com/v4/ipsw/15.0.2', headers=headers)

response_body = urlopen(request).read()

parsed = json.loads(response_body)

print(json.dumps(parsed, indent=4, sort_keys=True))
