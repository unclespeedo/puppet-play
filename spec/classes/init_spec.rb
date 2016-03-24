require 'spec_helper'
describe 'play' do

  context 'with defaults for all parameters' do
    it { should contain_class('play') }
  end
end
