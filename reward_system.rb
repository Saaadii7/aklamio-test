# frozen_string_literal: true

# RewardSystem.rb

require './rule'

class RewardSystem
  attr_reader :rules, :customer_puchases

  def initialize
    @rules = []
    @customer_puchases = [
      { customer_id: 65, purchase_amount_cents: 1800, created_at: Time.utc(2009, 1, 2, 6, 1) },
      { customer_id: 31_337, purchase_amount_cents: 6522, created_at: Time.utc(2009, 5, 4, 6, 12) },
      { customer_id: 4465, purchase_amount_cents: 987, created_at: Time.utc(2010, 8, 17, 11, 9) },
      { customer_id: 234_234, purchase_amount_cents: 200, created_at: Time.utc(2010, 11, 1, 16, 12) },
      { customer_id: 12_445, purchase_amount_cents: 1664, created_at: Time.utc(2010, 11, 18, 13, 19) },
      { customer_id: 234_234, purchase_amount_cents: 1200, created_at: Time.utc(2010, 12, 2, 16, 12) },
      { customer_id: 12_445, purchase_amount_cents: 1800, created_at: Time.utc(2010, 12, 3, 11, 17) },
      { customer_id: 65, purchase_amount_cents: 900, created_at: Time.utc(2011, 4, 28, 13, 16) },
      { customer_id: 65, purchase_amount_cents: 1600, created_at: Time.utc(2011, 5, 4, 11, 1) }
    ]
  end

  def start
    exit = false

    loop do
      print_menu

      menu = gets.chomp
      case menu
      when '1'
        add_rule
      when '2'
        see_all_rules
      when '3'
        clear_all_rules
      when '4'
        see_results
      when '0'
        exit = true
      else
        see_results
      end

      break if exit
    end
  end

  def clear_menu
    system 'clear'
  end

  def print_logo
    puts '#################################'
    puts '#    Customer Reward System     #'
    puts '#################################'
  end

  def print_menu
    clear_menu
    print_logo
    puts 'Menu'
    puts '1. Add New Rule.'
    puts '2. See All Rules.'
    puts '3. Clear All Rules.'
    puts '4. See Results.'
    puts '0. Exit.'
  end

  def add_rule
    clear_menu
    print_logo
    puts 'Add New Rule.'
    puts 'Please enter which type of Rule you want to add?'
    puts '1. Amount Rule.'
    puts '2. Time Duration Rule.'
    puts '3. Fixed Date Rule.'
    puts '0. Go Back.'

    type = $stdin.gets.chomp
    exit = false

    case type
    when '1'
      type = 'Amount'
      unit_description = 'Cents'
    when '2'
      type = 'Duration'
      unit_description = 'Days'
    when '3'
      type = 'Date'
      unit_description = 'No. of the day(0-31), of May month'
    when '0'
      exit = true
    else
      puts 'Invalid Input, Going back.'
      exit = true
    end

    return if exit

    system 'clear'
    print_logo
    puts 'Add New Rule.'
    puts "Please enter what threshold value you want to add for Rule Type: #{type}?"
    puts "Please add: #{unit_description}?"

    threshold = $stdin.gets.chomp

    rule = Rule.new(type: type, threshold: threshold)
    @rules.push(rule)
  end

  def see_all_rules
    (puts 'No Rules found!') if @rules.length.zero?
    @rules.map(&:print)
    puts 'Press any key to continue'
    $stdin.gets.chomp
  end

  def clear_all_rules
    @rules = []
  end

  def evaluate(rule, purchase)
    condition = case rule.type
                when 'Amount'
                  purchase[:purchase_amount_cents] >= rule.threshold
                when 'Duration'
                  (Time.now - (rule.threshold * 24 * 60 * 60)) < purchase[:created_at]
                when 'Date'
                  purchase[:created_at].month == 5 && purchase[:created_at].day == rule.threshold
                end

    condition ? rule : nil
  end

  def declare_reward_for(rule, purchase)
    reward = case rule.type
             when 'Amount'
               "#{purchase[:customer_id]} won: Next purchase free."
             when 'Duration'
               "#{purchase[:customer_id]} won: Twenty percent off next order."
             when 'Date'
               "#{purchase[:customer_id]} won: Star Wars themed item added to delivery."
             end

    puts reward
  end

  def see_results
    # state = {}
    @customer_puchases.each do |purchase|
      # check and behave for previous award if any for customer

      # fire all rules and get winner rule
      winner_rule = nil
      @rules.each do |rule|
        rule_evaluation = evaluate(rule, purchase)
        winner_rule = rule_evaluation.nil? ? winner_rule : rule_evaluation
      end

      # declare reward
      if winner_rule.nil?
        puts "#{purchase[:customer_id]} got nothing this time."
      else
        declare_reward_for(winner_rule, purchase)
      end
      # set state and print
    end
    puts 'Press any key to continue'
    $stdin.gets.chomp
  end
end
