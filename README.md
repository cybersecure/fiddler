Fiddler
=======

Ruby gem to provide an easy interface to Request Tracker Installation.

Installation
-------------

Install the gem using this commands

`gem install fiddler`

or you can include it in your Gemfile.

`gem 'fiddler'`

Configuration
--------------

For a Rails app, create an initializer files and for any other app, include this before using the gem.
<pre>
<code>
   Fiddler.configure do |config|
      config.server_url = "request_tracker_url"
      config.username = "some_user"
      config.password = "some_password"
   end
</code>
</pre>

You can modify the settings on the fly as well using `Fiddler.configuration` variable.

Attachments
-----------

Fiddler saves the attachments object in a folder specified by
`Fiddler.configuration.attachments_path`. This is relative to the rails
root.

Using Cookies
-------------

Make sure you have RT-External-Auth configured properly to use cookies with Request Tracker.
Once that part has been done, change the config file to the following format.

<pre>
<code>
   Fiddler.configure do |config|
      config.server_url = "request_tracker_url"
      config.use_cookies = true
      config.cookie_domain = ".domainname"
      config.request_tracker_key = "loginCookieValue"
   end
</code>
</pre>

Once the configuration is done, cookie value can be set using
`Fiddler.configuration.cookie_value` method (appropriate place for that
would be somewhere like ApplicationController where it can set
dynamically).

Debugging Response
------------------

You can set the config option `Fiddler.configuration.debug_response` to
`true` to start debugging the responses from RT. If using in rails, it
will log to the current environment log otherwise print it to the stdout.

SSL Verification
----------------

SSL certificate verification can be turned off by using
`Fiddler.configuration.ssl_verify` option. This is very helpful in jruby
implementations where ssl is bit of a pain.

Supported Versions of Request Tracker
-------------------------------------
* 4.0.4

License
-------
Do you what-ever you can with this product license.
