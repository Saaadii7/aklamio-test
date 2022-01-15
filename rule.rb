# frozen_string_literal: true

# rule.rb
# No validation for rule attribs

class Rule
  attr_reader :id, :type, :threshold

  @@rules = 0

  def initialize(type:, threshold: 0)
    @id = (@@rules += 1)
    @type = type
    @threshold = threshold.to_i
  end

  def print
    puts "This rule:#{@id} is of Type:#{@type} with Threshold:#{@threshold}"
  end
end
