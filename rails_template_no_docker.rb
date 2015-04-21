project_name = ask("What is the name of the project?")

run "rvm gemset create #{project_name}"
run "rvm gemset use #{project_name}"
run "gem install pg -v '0.18.1'"

gem 'devise'
gem 'bootstrap-sass'
gem 'haml'
gem 'haml-rails'

gem_group :test do
  gem 'rspec'
  gem 'selenium-webdriver', '>=2.45.0.dev3'
  gem 'capybara'
  gem 'factory_girl_rails'
  gem 'database_cleaner', "1.3.0"
  gem 'timecop'
end

gem_group :development do
  gem 'thin'
end

run "bundle install"

run 'rails generate devise:install'
run 'rails generate devise User'
environment 'config.action_mailer.default_url_options: {host: localhost, port: 3000}', env: 'production'
rake "db:create"
rake "db:migrate"

run "cd #{@app_name}"
run "rm app/assets/stylesheets/application.css"
run "touch app/assets/stylesheets/application.scss"
template = <<-TEMP
@import "bootstrap-sass/assets/stylesheets/bootstrap-sprockets";
@import "bootstrap-sass/assets/stylesheets/bootstrap";
TEMP
run "echo '#{template}' > app/assets/stylesheets/application.scss"

template = <<-TEMP
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require turbolinks
//= require_tree .
TEMP

run "rm app/assets/javascripts/application.js"
run "echo '#{template}' > app/assets/javascripts/application.js"

git :init
git add: '.'
git commit: "-a -m 'Initial Commit'"

