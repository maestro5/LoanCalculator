require 'spec_helper'
require_relative '../app/app'

def check_valid(method)
  assets = {
    standard: ['1', 'standard', '--standard', '-s'],
    annuity: ['2', 'annuity', '--annuity', '-a']
  }

  app = App.new %w(10 1000 12)

  assets[method].each do |asset|
    app.method = asset
    it { expect(app.method_valid?).to be true }
  end
end

describe App do
  describe '.method_assets' do
    let(:app) { App.new }
    it { expect(app.method_assets[:standard]).to_not be_empty }
    it { expect(app.method_assets[:annuity]).to_not be_empty }
  end # .method_assets

  describe '.method_valid?' do
    context 'valid' do
      describe 'standard' do
        check_valid :standard
      end # standard method

      describe 'annuity' do
        check_valid :annuity
      end # annuity method
    end # context valid

    context 'invalid' do
      it { expect(App.new(%w(10 1000 12)).method_valid?).to be false }
      it { expect(App.new(%w(10 1000 12 --some)).method_valid?).to be false }
      it { expect(App.new(%w(10 1000 12 5)).method_valid?).to be false }
      it { expect(App.new(%w(10 1000)).method_valid?).to be false }
    end # context invalid
  end # .method_valid?

  describe '.bad_command?' do
    context 'when false' do
      it { expect(App.new(%w(10 1000 12 -s)).bad_command?).to be false }
      it { expect(App.new(%w(10 1000 12 -a)).bad_command?).to be false }
      it { expect(App.new.bad_command?).to be false }
    end # when false

    context 'when true' do
      it { expect(App.new(%w(10 1000 12 -f)).bad_command?).to be_truthy }
      it { expect(App.new(%w(10 1000 -s)).bad_command?).to be_truthy }
      it { expect(App.new(%w(10 -annuity)).bad_command?).to be_truthy }
      it { expect(App.new(%w(10)).bad_command?).to be_truthy }
    end # when true
  end # .bad_command?

  describe '.available_methods' do
    it { expect(App.new.available_methods).to include('Available methods:') }
  end # .available_methods

  describe '.command_example' do
    let(:msg) { 'for example: $ ruby start.rb 10 1000 12 --annuity' }
    it { expect(App.new.command_example).to include(msg) }
  end # .command_example

  describe '.loan_create!' do
    it { expect(App.new(%w(10 1000 12 -s)).loan_create!).to be_kind_of(Standard) }
    it { expect(App.new(%w(10 1000 12 -a)).loan_create!).to be_kind_of(Annuity) }
  end # .loan_create!
end # App
