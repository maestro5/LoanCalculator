# Loan - base loan class
class Loan
  attr_accessor :interest, :sum, :term
  attr_reader   :error, :res, :params

  LANGUAGE = {
    parameters:     'Loan parameters:',
    interest:       'interest',
    sum:            'sum',
    term:           'term',
    method:         'count method',
    check_interest: 'The loan interest should be a positive number!',
    check_sum:      'The loan sum should be a positive number!',
    check_term:     'The loan term should be a positive integer number > 1!',
    set_interest:   'Please enter loan interest: ',
    set_sum:        'Please enter loan sum: ',
    set_term:       'Please enter loan term: ',
    h_line:         ' ' << '-' * 89 << ' ',
    v_line:         '|',
    month:          ' month ',
    m_payment:      '  monthly payment  ',
    repayment:    '    repayment %    ',
    o_contribution: ' overall contribution ',
    l_balance:      '   loan balance   '
  }

  def initialize(options = { interest: 0.0, sum: 0.0, term: 0 })
    @interest = options[:interest].to_f
    @sum      = options[:sum].to_f
    @term     = options[:term].to_i
    @res      = []
    @params   = {
      rate:           0,
      m_payment:      0,
      l_balance:      0,
      repayment:      0,
      o_contribution: 0
    }
  end

  def to_s
    LANGUAGE[:parameters] + ' ' +
    LANGUAGE[:interest] + " = #{@interest}%, " +
    LANGUAGE[:sum] + " = #{@sum}, " +
    LANGUAGE[:term] + " = #{@term}, " +
    LANGUAGE[:method] + ": #{self.class}"
  end

  def valid?(*args)
    clear_error!

    args.each do |validator_name|
      send "check_#{validator_name}!"
    end
    @error.nil?
  end

  def count!
    establish_options unless valid? :interest, :sum, :term

    @params[:rate]      = (@interest / @term / 100).round(7)
    @params[:l_balance] = @sum
  end

  def show
    columns = [:month, :m_payment, :repayment, :o_contribution, :l_balance]
    v_line  = LANGUAGE[:v_line]

    puts "\n#{self}"
    puts LANGUAGE[:h_line]
    puts columns.inject('') { |a, e| a + v_line + LANGUAGE[e] } + v_line
    puts LANGUAGE[:h_line]

    @res.each do |line|
      puts format_column(columns, line)
    end

    puts LANGUAGE[:h_line]
  end

  private

  def clear_error!
    @error = nil
  end

  def check_interest!
    @error = LANGUAGE[:check_interest] unless @interest.is_a?(Float) && @interest > 0
  end

  def check_sum!
    @error = LANGUAGE[:check_sum] unless @sum.is_a?(Float) && @sum > 0
  end

  def check_term!
    @error = LANGUAGE[:check_term] unless @term.is_a?(Integer) && @term > 1
  end

  def establish_options(*args)
    options = [:interest, :sum, :term]
    options.each do |option_name|
      until valid? option_name
        puts @error
        print LANGUAGE[:"set_#{option_name}"]
        if option_name == :term
          send("#{option_name}=", STDIN.gets.chomp.to_i)
        else
          send("#{option_name}=", STDIN.gets.chomp.to_f)
        end
      end
    end
  end

  def add_result_line(i)
    @params[:l_balance] -= @params[:m_payment]
    @params[:l_balance]  = 0 if @params[:l_balance] < 0
    @params[:l_balance]  = @params[:l_balance].round(2)

    @res += [{ month: i + 1 }.merge(@params)]
  end

  def format_column(columns, line)
    str = ''
    columns_size = columns.size - 1

    columns.each_with_index do |column, index|
      value  = line[column]
      value  = value unless column == :month
      value  = value.to_s
      indent = LANGUAGE[column].length - value.length - 1

      str += LANGUAGE[:v_line] + ' ' * indent + value << ' '
      str += LANGUAGE[:v_line] if index == columns_size
    end
    str
  end
end # Loan
