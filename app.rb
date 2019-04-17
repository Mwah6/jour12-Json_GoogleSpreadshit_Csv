require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'app/scrapper'


Scrapper.new.save_as_csv
# Scrapper.new.save_as_JSON
# Scrapper.new.save_as_spreadsheet

# 626743721469-5p6goqq9cd2lg9ovhun31f691cevu7q7.apps.googleusercontent.com

# -2B5wHmDbuWKtkkeJJTToUi7
