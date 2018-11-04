# Jets Rails for Mega Mode

This gem works in conjuction with [Jets](http://rubyonjets.com/) to allow you to run a Rails application on AWS Lambda. Jets automatically adds this gem to a Rails application as part of [Mega Mode Rails Support](http://rubyonjets.com/docs/rails-support/).  Here's a Blog Post Tutorial that covers Mega Mode: [Jets Mega Mode: Run Rails on AWS Lambda](https://blog.boltops.com/2018/11/03/jets-mega-mode-run-rails-on-aws-lambda).

## Usage

This gem is not meant to be used standalone. You can enable it though by adding to your Rails Gemfile and setting the `JETS_MEGA=1` env var.

## More Info

For more information about Jets and Rails Support refer to:

* [Ruby on Jets](http://rubyonjets.com)
* [AWS Lambda Ruby Support at Native Speed with Jets](https://blog.boltops.com/2018/09/02/aws-lambda-ruby-support-at-native-speed-with-jets)
* [Jets Rails Support](http://rubyonjets.com/docs/rails-support/)
* [Toronto Serverless Presentation: Jets Framework on AWS Lambda](https://blog.boltops.com/2018/09/25/toronto-serverless-presentation-jets-framework-on-aws-lambda)