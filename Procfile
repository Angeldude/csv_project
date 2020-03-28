web: bin/rails rails server -p $PORT -e $RAILS_ENV
worker: bundle exec sidekiq -e $RACK_ENV
release: bin/rails db:migrate