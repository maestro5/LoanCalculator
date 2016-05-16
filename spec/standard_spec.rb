require 'spec_helper'
require_relative '../app/standard'

describe Standard do
  describe '.count!' do
    standard_loan = Standard.new interest: 10, sum: 1000, term: 12
    standard_loan.count!

    res_first = {
      month:          1,
      rate:           0.0083333,
      m_payment:      83.33,
      l_balance:      916.67,
      repayment:      8.33,
      o_contribution: 91.66
    }

    res_eighth = {
      month:          8,
      rate:           0.0083333,
      m_payment:      83.33,
      l_balance:      333.36,
      repayment:      3.47,
      o_contribution: 86.8
    }

    it { expect(standard_loan.params[:m_payment]).to eq 83.33 }
    it { expect(standard_loan.res.size).to eq 12 }
    it { expect(standard_loan.res[0]).to eq res_first }
    it { expect(standard_loan.res[7]).to eq res_eighth }
  end # .count!
end # Standard
