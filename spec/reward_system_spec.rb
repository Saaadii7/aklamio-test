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

  describe '#evaluate' do
    let(:customer_id) { 65 }
    let(:rule) { Rule.new(type: type, threshold: threshold) }

    context 'Customer Purchase matching rules' do
      context 'Rule type Amount' do
        let(:type) { 'Amount' }
        let(:threshold) { 500 }

        let(:customer_puchase) do
          { customer_id: customer_id, purchase_amount_cents: 600, created_at: Time.utc(2009, 1, 2, 6, 1) }
        end

        it 'return winning Amount type rule' do
          expect(subject.evaluate(rule, customer_puchase)).to eq(rule)
        end
      end

      context 'Rule type Duration' do
        let(:type) { 'Duration' }
        let(:threshold) { 30 }

        let(:customer_puchase) do
          { customer_id: customer_id, purchase_amount_cents: 1800,
            created_at: (Time.now - ((threshold - 1) * 24 * 60 * 60)) }
        end

        it 'return winning Duration type rule' do
          expect(subject.evaluate(rule, customer_puchase)).to eq(rule)
        end
      end

      context 'Rule type Date' do
        let(:type) { 'Date' }
        let(:threshold) { 5 }

        let(:customer_puchase) do
          { customer_id: customer_id, purchase_amount_cents: 1800, created_at: Time.utc(2009, 5, threshold, 6, 1) }
        end

        it 'return winning Date type rule' do
          expect(subject.evaluate(rule, customer_puchase)).to eq(rule)
        end
      end
    end

    context 'Customer Purchase not matching rules' do
      context 'Rule type Amount' do
        let(:type) { 'Amount' }
        let(:threshold) { 500 }

        let(:customer_puchase) do
          { customer_id: customer_id, purchase_amount_cents: 400, created_at: Time.utc(2009, 1, 2, 6, 1) }
        end

        it 'return nil for non winning Amount type rule' do
          expect(subject.evaluate(rule, customer_puchase)).to eq(nil)
        end
      end

      context 'Rule type Duration' do
        let(:type) { 'Duration' }
        let(:threshold) { 30 }

        let(:customer_puchase) do
          { customer_id: customer_id, purchase_amount_cents: 1800,
            created_at: (Time.now - ((threshold + 1) * 24 * 60 * 60)) }
        end

        it 'return nil for non winning Duration type rule' do
          expect(subject.evaluate(rule, customer_puchase)).to eq(nil)
        end
      end

      context 'Rule type Date' do
        let(:type) { 'Date' }
        let(:threshold) { 5 }

        let(:customer_puchase) do
          { customer_id: customer_id, purchase_amount_cents: 1800, created_at: Time.utc(2009, 5, threshold + 1, 6, 1) }
        end

        it 'return nil for non winning Date type rule' do
          expect(subject.evaluate(rule, customer_puchase)).to eq(nil)
        end
      end
    end
  end

  describe '#declare_reward_for' do
    let(:customer_id) { 65 }
    let(:rule) { Rule.new(type: type, threshold: threshold) }

    context 'Rule type Amount' do
      let(:type) { 'Amount' }
      let(:threshold) { 500 }

      let(:customer_puchase) do
        { customer_id: customer_id, purchase_amount_cents: 600, created_at: Time.utc(2009, 1, 2, 6, 1) }
      end

      it 'prints a reward for Rule type: Amount' do
        expect do
          subject.declare_reward_for(rule, customer_puchase)
        end.to output("#{customer_id} won: Next purchase free.\n").to_stdout
      end
    end

    context 'Rule type Duration' do
      let(:type) { 'Duration' }
      let(:threshold) { 30 }

      let(:customer_puchase) do
        { customer_id: customer_id, purchase_amount_cents: 1800,
          created_at: (Time.now - ((threshold - 1) * 24 * 60 * 60)) }
      end

      it 'prints a reward for Rule type: Duration' do
        expect do
          subject.declare_reward_for(rule,
                                     customer_puchase)
        end.to output("#{customer_id} won: Twenty percent off next order.\n").to_stdout
      end
    end

    context 'Rule type Date' do
      let(:type) { 'Date' }
      let(:threshold) { 5 }

      let(:customer_puchase) do
        { customer_id: customer_id, purchase_amount_cents: 1800, created_at: Time.utc(2009, 5, threshold, 6, 1) }
      end

      it 'prints a reward for Rule type: Date' do
        expect do
          subject.declare_reward_for(rule,
                                     customer_puchase)
        end.to output("#{customer_id} won: Star Wars themed item added to delivery.\n").to_stdout
      end
    end
  end

  describe '#see_results' do
    let(:customer_id) { 12_445 }

    context 'when no rule matches' do
      let(:customer_puchase) do
        { customer_id: customer_id, purchase_amount_cents: 1800, created_at: Time.utc(2009, 5, 5, 6, 1) }
      end

      it 'prints a sensible output for that case' do
        allow($stdin).to receive(:gets).and_return('')
        expect { subject.see_results }.to output(match("#{customer_id} got nothing this time.\n")).to_stdout
      end
    end

    context 'when rules matches' do
      before do
        subject.rules.push(Rule.new(type: 'Date', threshold: 4))
      end

      context 'for one purchase' do
        before do
          subject.rules.push(Rule.new(type: 'Amount', threshold: 1500))
        end

        it 'prints reward for newest rules' do
          allow($stdin).to receive(:gets).and_return('')
          expect { subject.see_results }.to output(match("Next purchase free.\n")).to_stdout
        end
      end

      context 'for multiple purchases' do
        before do
          subject.rules.push(Rule.new(type: 'Amount', threshold: 6500))
        end

        it 'return contidion for winning rule' do
          allow($stdin).to receive(:gets).and_return('')
          expect { subject.see_results }.to output(match("Next purchase free.\n")).to_stdout
        end
      end
    end
  end
end
