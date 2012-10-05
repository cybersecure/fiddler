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

Using Cookies
-------------

Make sure you have RT-External Auth configuration properly to use cookies with Request Tracker.
Once that part has been done, change the config file to the following format.

<pre>
   <code>
      Fiddler.configure do |config|
         config.server_url = "request_tracker_url"
         config.use_cookies = true
         config.cookie_options = {:cookie_domain => "*.domainname", :login_cookie_key => "some_key_for_rt" }
      end
   </code>
</pre>

Once the configuration is done, cookie value can be set using `Fiddler.configuration.cookie_value` method.

Supported Versions of Request Tracker
-------------------------------------
* 4.0.4

License
-------
Do you what-ever you can with this product license.