require 'spec_helper'
describe 'sipproxy' do

  context 'with defaults for all parameters' do
    it { should contain_class('sipproxy') }
  end
end
