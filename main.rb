# frozen_string_literal: true

# main.rb

require './rule'

Rule.new(type: 'Amount', threshold: 500).print
Rule.new(type: 'Duration', threshold: 30).print
Rule.new(type: 'Date', threshold: 5).print
