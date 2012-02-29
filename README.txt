Created by these commands:
- mkdir cookbooks
- spatula install git
- spatula install build-essential
- spatula install nodejs
- git submodule add https://github.com/librato/statsd-cookbook cookbooks/statsd
- mkdir config
- #write node.json and solo.rb

To run:
- bundle install
- spatula prepare HOST
- spatula cook HOST node