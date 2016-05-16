require_relative 'standard'

# App - loan application
class App
  attr_reader :args, :loan
  attr_accessor :method

  LANGUAGE = {
    available_methods: 'Available methods: ',
    command_example:   'Correct command format:' \
                        "\n   $ ruby start.rb [interest] [sum] [term] (method)" \
                        "\n   for example: $ ruby start.rb 10 1000 12 --annuity",
    invalid_method:     'Error! Invalid count method!'
  }

  def initialize(args = [])
    @args    = args
    @method  = args[3]
    @options = { interest: args[0], sum: args[1], term: args[2] }
  end

  def method_assets
    {
      standard: ['1', 'standard', '--standard', '-s'],
      annuity: ['2', 'annuity', '--annuity', '-a']
    }
  end

  def method_valid?
    return false if @method.nil?
    method_assets[:standard].include?(@method) || method_assets[:annuity].include?(@method)
  end

  def bad_command?
    return false if @args.empty?
    @args.size < 4 || !method_valid?
  end

  def available_methods
    str = LANGUAGE[:available_methods]
    method_assets.each { |a| str += "\n   #{a[0].capitalize}: #{a.join(', ')}" }
    str << "\n"
  end

  def command_example
    LANGUAGE[:command_example]
  end

  def loan_create!
    @loan = Standard.new(@options) if method_assets[:standard].include?(@method)
    @loan = Annuity.new(@options)  if method_assets[:annuity].include?(@method)
    @loan
  end

  def receive_valid_method
    until method_valid?
      print 'Enter count method 1 - standard, 2 - annuity: '
      @method = STDIN.gets.chomp

      unless method_valid?
        @method = nil
        puts LANGUAGE[:invalid_method]
      end
    end
  end
end # App
