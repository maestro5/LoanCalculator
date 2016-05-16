require_relative 'loan'

# Annuity - count loan by annuity method
class Annuity < Loan
  def count!
    super

    rate = @params[:rate]
    k    = (rate * (1 + rate)**@term) / ((1 + rate)**@term - 1)

    @params[:o_contribution] = (@params[:l_balance] * k).round(2)

    @term.times do |i|
      @params[:repayment] = (rate * @params[:l_balance]).round(2)
      @params[:m_payment] = (@params[:o_contribution] - @params[:repayment]).round(2)

      add_result_line i
    end

    @res
  end
end # Annuity
