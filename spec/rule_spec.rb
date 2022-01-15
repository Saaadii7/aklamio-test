# frozen_string_literal: true

require './rule'

RSpec.describe Rule do
  describe 'has an id' do
    it 'return generates incremental ID' do
      rule1 = Rule.new(type: 'Amount')
      rule2 = Rule.new(type: 'Amount')
      rule3 = Rule.new(type: 'Amount')
      expect(rule2.id).to eq((rule1.id + 1))
      expect(rule3.id).to eq((rule2.id + 1))
    end
  end

  describe 'has a type' do
    context 'when Amount' do
      it 'return rule with Amount type' do
        rule = Rule.new(type: 'Amount')
        expect(rule.type).to eq('Amount')
      end
    end

    context 'when Duration' do
      it 'return rule with Duration type' do
        rule = Rule.new(type: 'Duration')
        expect(rule.type).to eq('Duration')
      end
    end

    context 'when Date' do
      it 'return rule with Date type' do
        rule = Rule.new(type: 'Date')
        expect(rule.type).to eq('Date')
      end
    end
  end

  describe '#initialize' do
    context 'when not given required params' do
      it 'will not create rule instance' do
        expect { Rule.new }.to raise_error(ArgumentError)
      end
    end

    context 'when given required params' do
      it 'will create rule' do
        expect(Rule.new(type: 'Date').class).to eq(Rule)
      end
    end
  end

  describe '#print' do
    it 'prints the detail of a rule' do
      rule = Rule.new(type: 'Amount')
      expect do
        rule.print
      end.to output("This rule:#{rule.id} is of Type:#{rule.type} with Threshold:#{rule.threshold}\n").to_stdout
    end
  end
end
