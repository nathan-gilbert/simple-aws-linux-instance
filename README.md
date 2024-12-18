# Simple AWS EC2

A simple AWS EC2 instance running a Flask application.

1. run `tofu apply` to setup
2. run `tofu destroy` to tear down

## Notes

Can't use the global mac or linux `linode-cli`, must install via Python because `boto3` is also
required to work with Linode storage buckets.
