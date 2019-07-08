require 'spec_helper'
describe 'opensips_control_panel' do
  context 'with default values for all parameters' do
    it { should contain_class('opensips_control_panel') }
  end
end
