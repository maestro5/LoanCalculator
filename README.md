# Loan calculator
#### Calculated monthly payments by standard and annuity methods

## Usage
Inline command format `$ ruby start.rb [interest] [sum] [term] [method]`
```
$ ruby start.rb 10 1000 12 -s (1, standard, --standard)
$ ruby start.rb 10 1000 12 -a (2, annuity, --annuity)
```
Or run `$ ruby start.rb` and follow the instructions.

![Alt text](example.png?raw=true "Examples")

Run tests `$ rspec spec`