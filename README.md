# opsworks-route53

The purpose of this cookbook is to automatically update route53 DNS zone records of Amazon EC2 hosts that are managed by OpsWorks.


## Assumptions

- This cookbook is meant to work within an AWS OpsWorks environment.  Your mileage may vary in other environments.
- Route53 is being used to manage DNS


## Requirements

- Amazon Linux (tested on 2015.03)
- Chef (tested on 11.10)
- Berkshelf (tested on 3.2.0)


## Usage

- Setup the following custom JSON in the relevant OpsWorks stack(s):
```json
{  
  "private_settings": {
    "dns": {
      "zone_id": "<enter zone id>",
      "domain": "<enter domain (e.g. domain.com)>",
      "ttl": <enter ttl>
    }
  }
```
- Include the following policy in the OpsWorks stack instance profile so that OpsWorks provisioned instances can manage their DNS records:
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets",
                "route53:GetHostedZone",
                "route53:ListResourceRecordSets"
            ],
            "Resource": "*"
        }
    ]
}
```
- Reference this recipe in your Berksfile in the stacks where you will use it:
```text
cookbook 'opsworks-route53', git: 'git://github.com/tomalessi/opsworks-route53.git'
```
- Include this recipe as part of the `configure` lifecycle event.


## License and Authors

- Author: Tom Alessi (tom.alessi@gmail.com)

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

