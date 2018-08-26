require 'pp'

RSpec.describe Hash do
  it 'is used by RSpec metadata' do |example|
    pp example.metadata
  end
end
