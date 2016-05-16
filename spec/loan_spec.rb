require 'spec_helper'
require_relative '../app/loan'

describe Loan do
  describe '.to_s' do
    let(:loan) { Loan.new interest: 10, sum: 1000, term: 12 }
    let(:msg) { 'Loan parameters: interest = 10.0%, sum = 1000.0, term = 12' }
    it { expect(loan.to_s).to include msg }
  end # .to_s

  describe '.valid?' do
    context 'when interest invalid' do
      loan = Loan.new interest: 0, sum: 1000, term: 12
      it { expect(loan.valid?(:interest)).to be false }
      loan.interest = -5
      it { expect(loan.valid?(:interest)).to be false }
      loan.interest = 'n'
      it { expect(loan.valid?(:interest)).to be false }
      loan.interest = ''
      it { expect(loan.valid?(:interest)).to be false }

      it { expect(loan.valid?(:interest, :sum, :term)).to be false }
    end # when interest invalid

    context 'when sum invalid' do
      loan = Loan.new interest: 15, sum: 0, term: 12
      it { expect(loan.valid?(:sum)).to be false }
      loan.sum = -5
      it { expect(loan.valid?(:sum)).to be false }
      loan.sum = 'n'
      it { expect(loan.valid?(:sum)).to be false }
      loan.sum = ''
      it { expect(loan.valid?(:sum)).to be false }

      it { expect(loan.valid?(:interest, :sum, :term)).to be false }
    end # when sum invalid

    context 'when term invalid' do
      loan = Loan.new interest: 10, sum: 1000, term: 0
      it { expect(loan.valid?(:term)).to be false }
      loan.term = 1
      it { expect(loan.valid?(:term)).to be false }
      loan.term = -5
      it { expect(loan.valid?(:term)).to be false }
      loan.term = 'n'
      it { expect(loan.valid?(:term)).to be false }
      loan.term = ''
      it { expect(loan.valid?(:term)).to be false }

      it { expect(loan.valid?(:interest, :sum, :term)).to be false }
    end # when term invalid

    context 'when few options invalid' do
      loan = Loan.new interest: 10, sum: 'k', term: 1
      it { expect(loan.valid?(:interest, :sum, :term)).to be false }

      loan = Loan.new interest: -105, sum: 1000, term: 1
      it { expect(loan.valid?(:interest, :sum, :term)).to be false }

      loan = Loan.new interest: 'd', sum: -900, term: 24
      it { expect(loan.valid?(:interest, :sum, :term)).to be false }

      loan = Loan.new interest: 0, sum: -3, term: nil
      it { expect(loan.valid?(:interest, :sum, :term)).to be false }
    end # when all options invalid

    context 'when valid' do
      loan = Loan.new interest: 10, sum: 1000, term: 2
      it { expect(loan.valid?(:interest)).to be true }
      it { expect(loan.valid?(:sum)).to be true }
      it { expect(loan.valid?(:term)).to be true }
      it { expect(loan.valid?(:interest, :sum, :term)).to be true }
    end # when valid
  end # .valid?

  describe '.count!' do
    loan = Loan.new interest: 10, sum: 1000, term: 12
    loan.count!
    it { expect(loan.params[:rate]).to eq 0.0083333 }
    it { expect(loan.params[:l_balance]).to eq 1000.00 }
  end # .count!
end # Loan
