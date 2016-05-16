require_relative 'loan'

# Standard - count loan by standard method
class Standard < Loan
  def count!
    super

    @params[:m_payment] = (@sum / @term).round(2)

    @term.times do |i|
      @params[:repayment]      = (@params[:rate] * @params[:l_balance]).round(2)
      @params[:o_contribution] = (@params[:m_payment] + @params[:repayment]).round(2)

      add_result_line i
    end

    @res
  end
end # Standard
