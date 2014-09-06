# chefenv

Super rough initial stab at chefenv, sort of like rbenv for users of
Chef. 

## Why would you want this?

If you interact with a number of different Chef servers in a given day,
this is for you! In particular, I have been using this model for years
now and never got around to codifying it until now. It lets you do
something like the following:

```
set -x CHEF_ENV devserver
knife node list 
knife role list 
```

And in another terminal say:

```
set -x CHEF_ENV prodserver
knife role edit web_server
``` 

And interact with multiple servers simultaneously without having to
monkey with config file flags or other things. 

## How to use

* Install
* chefenv init
* chefenv create envname
* export CHEF_ENV=envname
* knife role list (or whatever)

## What to expect

Right now, nothing. It works but it's still ugly. However I wanted to
get something pushed up so this is where we are. Think of this as v0.0.1

## Where this is going

In the end, I would like for this to manage all your knife/chef-client
preferences for workstations but also be able to do things like manage
the version of the Chef client you are using (probably via RVM or
similar mechanism)

## Contributing

Fork it ( https://github.com/johnewart/chefenv/fork )
Create your feature branch (git checkout -b my-new-feature)
Commit your changes (git commit -am 'Add some feature')
Push to the branch (git push origin my-new-feature)
Create a new Pull Request

## License

Copyright 2014 John Ewart <john@johnewart.net>. Released under the Apache 2.0 license. See the file LICENSE for further details.
