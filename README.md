Tiktalik JS
===========

A command line tool and coffeescript library for interacting with [Tiktalik Cloud Platform](http://tiktalik.com).

It is early version and shoul be used with caution. May still have some bugs.
Feel free to create issues and/or merge requests.

## Instalation

    npm install -g tiktalik-js

## Configuration

Application requires API Key and API Secret to access user account.
API keys can be generated in [Tiktalik Panel](http://tiktalik.com/panel) in section "API Keys".

Currently configuration can be set as environment variables:

    export TIKTALIK_KEY="<tiktalik api key>"
    export TIKTALIK_SECRET="<tiktalik api secret>"

It is also possible to pass api keys as command line params like that:

    tiktalikjs --key "<tiktalik api key>" --secret "<tiktalik api secret>" ...

## Fuzzy uuid/name matching

Using Tiktalik JS command line tool can be much easier if you do not need to remember uuid or names of your instances or networks. So it is possible to fuzzy search object that you are looking for.
For example:

### Fuzzy UUID (available for instance, image, network etc.)

    $ tiktalikjs instance info 7d3ba0ef

    Hostname:         dnlek-test1
    UUID:             7d3ba0ef-7995-4981-a1db-7c7c25413707
    Status:           running
    IPs:              37.233.98.123
    Image UUID:       4a2b3e72-47f1-4e88-b482-1834478ade28
    Size ID:          1

### Fuzzy name (availabe for instance, image, network etc.)

When more then one result was found.

    $ tiktalikjs instance info test
    Found more then one instance (3)
    0) dnlek-test1 (7d3ba0ef-7995-4981-a1db-7c7c25413707)
    1) test-api (480a37d7-ca06-4feb-883e-23ce0fefc4e7)
    prompt: number:  
    ...

When no result was found

    $ tiktalikjs instance info XDsd
    Instance not found

When one result was found

    $ tiktalikjs instance info dnlek

    Hostname:         dnlek-test1
    UUID:             7d3ba0ef-7995-4981-a1db-7c7c25413707
    Status:           running
    IPs:              37.233.98.123
    Image UUID:       4a2b3e72-47f1-4e88-b482-1834478ade28
    Size ID:          1


### Common operation parameters

Each asynchronous Tiktalik JS command has (-w, --wait) parameter. It indicates that we want to wait until command will be finished.

## Usage

### List your Tiktalik Instances

    $ tiktalikjs instance list
    dnlek-test1 (ip: 37.233.98.123, running: true, uuid: 7d3ba0ef-7995-4981-a1db-7c7c25413707)
    playground1 (ip: 37.233.98.124, running: true, uuid: 5ae43c8d-1b44-460c-9b28-a8aebfb4ea26)
    test-api (ip: 37.233.98.125, running: false, uuid: 480a37d7-ca06-4feb-883e-23ce0fefc4e7)

### SSH into Tiktalik Instance

    $ tiktalikjs instance ssh --ssh_key ~/.ssh/id_dsa.pub test-api
    Executing SSH into test-api instance...
    [root@test-api ~]

### Info about Tiktalik Instance

    $ tiktalikjs instance info dnlek-test1

    Hostname:         dnlek-test1
    UUID:             7d3ba0ef-7995-4981-a1db-7c7c25413707
    Status:           running
    IPs:              37.233.98.123
    Image UUID:       4a2b3e72-47f1-4e88-b482-1834478ade28
    Size ID:          1

### Start Tiktalik Instance

    $ tiktalikjs instance start --wait test-api
    Operation Start in progress..................done

### Shutdown Tiktalik Instance

    Graceful shutdown uses ACPI shutdown method.

    $ tiktalikjs instance stop --wait test-api
    Operation Stop in progress......................done

### Force shutdown Tiktalik Instance

    Forces instance shutdown.

    $ tiktalikjs instance shutdown --wait test-api
    Operation Shut Down in progress.................done

### Restart Tiktalik Instance

    $ tiktalikjs instance restart test-api
    Operation Restart in progress..........................done

### Destroy Tiktalik Instance

    $ tiktalikjs instance destroy test-api
    prompt: Warning! Potentially destructive action. Please confirm [y/n]:
    Operation Destroy in progress..........................done

### Create Tiktalik Instance

    $ tiktalikjs instance create --size 1 --image "Debian 7" --network "p3" --wait test-api2


## TODO

 [x] SSH into selected instance
 [ ] Better operations progress
 [ ] Images operations
 [ ] Networks operations
 [ ] Loadbalancers operations
