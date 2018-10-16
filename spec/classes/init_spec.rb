require 'spec_helper'
describe 'play' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('play') }
  end
end
