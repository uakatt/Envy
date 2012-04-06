Envy
=======

Introduction
------------

Envy is a web application coupled with some queue-processing and a Faye server, and scheduling. It "collates" input from various sources, which for now includes:

* JavaMelody (via the melodie gem)
* New Relic (via the lick gem)
* Firefox HTTP access to tracked web applications (via Selenium)
* Envy's Database (via ActiveRecord)

It saves the data that it collects, and presents it in the web application. Metrics can be requested from the web application, or on a schedule via resque.

Compatibility
-------------

Envy is tested on

* **ruby-1.9.3** on **Linux**

That is all.

Roadmap
-------

* So much...

Installation
------------

    git clone the_repository

_wah wah_ sound.

Contributing
------------

Please do! Contributing is easy. Please read the CONTRIBUTING.md document for more info. ... When it exists.

Usage
-----

Envy is meant to be used primarily as a web application, and a few other processes. Here's how I start the whole damn thing up. It takes a lot of terminal windows. Here's the resque server:

    $ QUEUE='*' rake resque:work

In another terminal, the Private Pub server:

    $ rackup private_pub.ru -s thin -E production

In another terminal, the resque-scheduler:

    $ rake resque:scheduler

And lastly, in another terminal, the Rails server:

    $ export RAILS_RELATIVE_URL_ROOT=/envy
    $ bundle exec rails server -d -e production

I totally acknowledge that `RAILS_RELATIVE_URL_ROOT` is a weird way to go... If you want the app available at `localhost:3000/`, then don't do that step, and comment out lines 4 and 6 in `config.ru`.

This should get you going! Now you can navigate to `http://localhost:3000/` and start defining environments.

Versioning
----------

Envy follows [Semantic Versioning](http://semver.org/) (at least approximately) version 2.0.0-rc1.

License
-------

Please see [LICENSE.md](LICENSE.md).

