# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

#if Rails.env.production? && ENV['SECRET_TOKEN'].blank?
#  fail 'The SECRET_TOKEN environment variable is not set on your production' \
#  ' server. To generate a random token, run "rake secret" from the command' \
#  ' line, then set it in production. If you\'re using Heroku, you can set it ' \
#  'like this: "heroku config:set SECRET_TOKEN=the_token_you_generated".'
#end

if Rails.env.production?
  ENV['SECRET_TOKEN'] = '38f811558413c17fa154c054ec529604a79a26ed6f13138659f78eff15c3fc116a462d058762111eb72b755a6f0d68c20e11ea0eee8be2d11f7a397b7004bcf7'
else
  fail 'Production Mode running Failed'
end

# Make sure the secrets in this file are kept private
# if you're sharing your code publicly.
OhanaApi::Application.config.secret_key_base = ENV['SECRET_TOKEN'] || '44cd5d3990ada5d792a06bd92c796edf8474dc92c1e88eecb458d524776ee26703260a07338cfede45db5246d4afcff74965a034fed46dbd1d424dc857f7748b'
