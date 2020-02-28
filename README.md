# Decidim::Apiauth

[![Build Status](https://travis-ci.org/mainio/decidim-module-apiauth.svg?branch=master)](https://travis-ci.org/mainio/decidim-module-apiauth)
[![codecov](https://codecov.io/gh/mainio/decidim-module-apiauth/branch/master/graph/badge.svg)](https://codecov.io/gh/mainio/decidim-module-apiauth)

A [Decidim](https://github.com/decidim/decidim) module to add JWT token based
API authentication possibility to Decidim.

The API authentication module provides a new endpoint for API authentication and
a method to check for an active authentication token header for each request.

Based on [Devise::JWT](https://github.com/waiting-for-dev/devise-jwt).

The development has been sponsored by the
[City of Helsinki](https://www.hel.fi/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-apiauth"
```

And then execute:

```bash
$ bundle
$ bundle exec rails decidim_apiauth:install:migrations
$ bundle exec rails db:migrate
```

Then, configure a secret key by adding the following to your application's
`config/secrets.yml`:

```yaml
development:
  <<: *default
  # ...
  secret_key_jwt: generate_a_key_here

test:
  <<: *default
  # ...
  secret_key_jwt: generate_a_key_here

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  <<: *default
  # ...
  secret_key_jwt: <%= ENV["SECRET_KEY_JWT"] %>
```

You can generate the key from the console by running:

```bash
$ bundle exec rails secret
abcdef123456... <-- (This printed line is the secret)
```

## Usage

TBD

## Contributing

See [Decidim](https://github.com/decidim/decidim).

### Testing

To run the tests run the following in the gem development path:

```bash
$ bundle
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rake test_app
$ DATABASE_USERNAME=<username> DATABASE_PASSWORD=<password> bundle exec rspec
```

Note that the database user has to have rights to create and drop a database in
order to create the dummy test app database.

In case you are using [rbenv](https://github.com/rbenv/rbenv) and have the
[rbenv-vars](https://github.com/rbenv/rbenv-vars) plugin installed for it, you
can add these environment variables to the root directory of the project in a
file named `.rbenv-vars`. In this case, you can omit defining these in the
commands shown above.

### Test code coverage

If you want to generate the code coverage report for the tests, you can use
the `SIMPLECOV=1` environment variable in the rspec command as follows:

```bash
$ SIMPLECOV=1 bundle exec rspec
```

This will generate a folder named `coverage` in the project root which contains
the code coverage report.

## License

See [LICENSE-AGPLv3.txt](LICENSE-AGPLv3.txt).
