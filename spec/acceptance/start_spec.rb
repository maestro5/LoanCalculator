def parse_output(output)
  res = []
  output_array = output.split("\n")
  output_array.each { |line| res << line.delete('|').split }
  res
end

def check_result_output(method, title, real_1, real_3)
  assets = {
    standard: ['1', 'standard', '--standard', '-s'],
    annuity: ['2', 'annuity', '--annuity', '-a']
  }

  assets[method].each do |key|
    let(:output) { parse_output `ruby start.rb 10, 1000, 12, #{key}` }

    it "with asset [#{key}], should return result title" do
      expect(output[1].join(' ')).to eq title
    end

    it "with asset [#{key}], line 1 should return correct result" do
      expect(output[5]).to eq real_1
    end

    it "with asset [#{key}], line 3 should return correct result" do
      expect(output[7]).to eq real_3
    end
  end
end

describe 'Valid parameters.' do
  describe 'Standard method' do
    title  = 'Loan parameters: interest = 10.0%, sum = 1000.0, term = 12, count method: Standard'
    real_1 = ['1', '83.33', '8.33', '91.66', '916.67']
    real_3 = ['3', '83.33', '6.94', '90.27', '750.01']

    check_result_output :standard, title, real_1, real_3
  end # standard method

  describe 'Annuity method' do
    title  = 'Loan parameters: interest = 10.0%, sum = 1000.0, term = 12, count method: Annuity'
    real_1 = ['1', '79.59', '8.33', '87.92', '920.41']
    real_3 = ['3', '80.92', '7.0', '87.92', '759.24']

    check_result_output :annuity, title, real_1, real_3
  end # annuity method
end # valid parameters

describe 'Bad command' do
  commands = [
    { args: '10 1000 12 -f', context: 'with invalid method' },
    { args: '10 1000 -s',    context: 'with invalid term without method' },
    { args: '10 1000',       context: 'without term and methot' },
    { args: '10 0 0 --some', context: 'with invalid sum, term and method' },
    { args: '10 -a',         context: 'with invalid sum without term and method' },
    { args: '--annuity',     context: 'with invalid interest without sum, term and method' }
  ]

  let(:available_msg) { 'Available methods:' }
  let(:example_msg) { 'for example: $ ruby start.rb 10 1000 12 --annuity' }

  commands.each do |arg|
    context "[ $ ruby start.rb #{arg[:args]} ] #{arg[:context]}" do
      it 'should include message with available methods' do
        expect(`ruby start.rb #{arg[:args]}`).to include(available_msg)
      end

      it 'should include message with correct command example' do
        expect(`ruby start.rb #{arg[:args]}`).to include(example_msg)
      end
    end
  end
end # bad command
