# Flick Scrape

This is a stopgap script to scrape daily usage data from Flick.

## Dependencies
- Written for ruby 2.3.0, but should run on >= 1.9.3
- Firefox

## Usage

- `bundle install`
- Open `main.rb`, and change the constants, `EMAIL` and `PASSWORD` to your email and password.
- `bundle exec ruby main.rb`

Data is outputted as CSV to `flick_usage.csv`
