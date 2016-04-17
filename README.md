# Socialkit

Is a toolkit that filters data from social services and publishes them to Volt for real time processing.
Dev real time endpoint is hard coded at localhost:3000 (will be configurable soon).

## Installation

- Install lmdb using your favorite packaging system.

    ```brew install lmdb```

- Install Gem
    - Grab code from github
    - Run build
        ```gem build socialkit.gemspec```
    - Run Install
        ```gem install social-<INSERT VERSION>.gem```

## Usage

- Add a config.yml file to current dir

Sample:
      starbucks:    
       services:
           twitter:
             key: XXXX
             secret: XXX



- Once the correct Config is in its place.  simply run the gem's binary
    ```socialkit```
