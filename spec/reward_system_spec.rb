# frozen_string_literal: true

require './reward_system'

RSpec.describe RewardSystem do
  subject { RewardSystem.new }

  describe '#initialize' do
    it 'return generates empty rules' do
      expect(subject.rules).to be_empty
    end

    it 'return generates some customer purchases' do
      expect(subject.customer_puchases.size).to eq(9)
    end
  end

  describe '#add_rule' do
    it 'return adds a rule into the system' do
      allow($stdin).to receive(:gets).and_return('1')

      expect { subject.add_rule }.to change { subject.rules.size }.by(1)
    end
  end

  describe '#see_all_rules' do
    context 'when no rules' do
      it 'prints no rules found.' do
        allow($stdin).to receive(:gets).and_return('')
        expect { subject.see_all_rules }.to output(match("No Rules found!\n")).to_stdout
      end
    end

    context 'when some rules' do
      it 'return rule with Duration type' do
        allow($stdin).to receive(:gets).and_return('')
        expect { subject.see_all_rules }.to output(match("No Rules found!\n")).to_stdout
      end
    end
  end

  describe '#clear_all_rules' do
    context 'when already have no rules' do
      it 'clears system rules.' do
        subject.clear_all_rules
        expect(subject.rules.size).to eq(0)
      end
    end

    context 'when already have rules' do
      before do
        subject.rules.push(Rule.new(type: 'Amount', threshold: 6500))
      end

      it 'clears system rules' do
        subject.clear_all_rules
        expect(subject.rules.size).to eq(0)
      end
    end
  end

  describe '#see_results' do
    context 'when no rule matches' do
    end

    context 'when rules matches' do
      context 'for one purchase' do
      end

      context 'for multiple purchases' do
      end
    end
  end
end
