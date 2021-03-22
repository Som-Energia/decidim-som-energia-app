# PARTICIPA.SOMENERGIA.COOP

## Deploying the app

Deployed with [Capistrano](http://capistranorb.com/) using [Figaro](https://github.com/laserlemon/figaro) for `ENV` configuration.

```bash
cap integration deploy
```

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:

```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```

1. Visit `<your app url>/system` and login with your system admin credentials
2. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
3. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
4. Fill the rest of the form and submit it.

You're good to go!
