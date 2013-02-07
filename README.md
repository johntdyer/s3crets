# S3crets

s3crets looks for a YAML config file and performs a deep merge against a directory of json files but only if the top level yaml key is present in the destination JSON file.  This ensures your secrets are only merged into the files you intended.  The purpose of s3crets was to help us keep secrets out of configuration JSON, which is kept in source control.

## Installation

Add this line to your application's Gemfile:

    gem 's3crets'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3crets

## Usage

Secrets takes 3 arguments, of which only 2 are required `[:json_dir, :secrets_file]`

```bash
    -s, --secrets-file FILE          Secret file to merge into JSON (required)
    -j, --json-dir DIR               Directory to search for json files (required)
    -o, --overwrite                  Overwrite JSON, default is false which will add '.new' to the file name, eg: something.json -> something.new.json
```

### Example Secrets File:

```json
mysql:
    server_repl_password: 11111
    server_root_password: 22222
    server_debian_password: 33333
random:
    config: something
```

Example JSON File

```json
{
  "node_type": "management-slave_server",
  "run_list": "recipe[management-slave_server]",
  "mysql": {
    "server_root_password": 22222,
    "server_repl_password": 11111,
    "server_debian_password": 33333
  },
  "prism": {
    "console": {
      "realm": "ProvisioningRealm"
    }
  },
  "provisioning_api": {
    "brokers": [
      "management1.qa.voxeolabs.net",
      "management2.qa.voxeolabs.net"
    ],
    "jdbc_url": "jdbc:mysql://management1.qa.voxeolabs.net:3306/provisioning"
  }
}
```

If the preceeding secrets file is applied against the JSON file above only the mysql key will be merged in, since s3crets assumes all top level keys in the JSON object are correct.  This allows you to have one secrets file and apply it against multiple JSON templates and only the indended data will be merged in.

## Examples

##### Applying Secrets while perserving original JSON files
```bash
s3crets --secrets-file ~/Projects/deployment_models/full_ha_deployment_model/.secrets --json-dir ~/Projects/deployment_models/full_ha_deployment_model/ec2_json
```

##### Applying Secrets to original JSON files
```bash
s3crets --secrets-file ~/Projects/deployment_models/full_ha_deployment_model/.secrets --json-dir ~/Projects/deployment_models/full_ha_deployment_model/ec2_json  --overwrite
```
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
