require 'spec_helper'
require_relative '../app/annuity'

describe Annuity do
  describe '.count!' do
    standard_loan = Annuity.new interest: 10, sum: 1000, term: 12
    standard_loan.count!

    res_first = {
      month:          1,
      rate:           0.0083333,
      m_payment:      79.59,
      l_balance:      920.41,
      repayment:      8.33,
      o_contribution: 87.92
    }

    res_eighth = {
      month:          8,
      rate:           0.0083333,
      m_payment:      84.35,
      l_balance:      344.42,
      repayment:      3.57,
      o_contribution: 87.92
    }

    it { expect(standard_loan.params[:m_payment]).to eq 87.19 }
    it { expect(standard_loan.res.size).to eq 12 }
    it { expect(standard_loan.res[0]).to eq res_first }
    it { expect(standard_loan.res[7]).to eq res_eighth }
  end # .count!
end # Standard
