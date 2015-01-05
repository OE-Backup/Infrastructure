require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'pp2-as::default' do
  
  let(:chef_run) {
    ChefSpec::Runner.new({
      cookbook_path: os[:cookbook_path],
      platform:      os[:platform],
      version:       os[:version],
    }) do |node| 
      # Define node variables
      # node.set['asd'] = 'value'
    end #.converge(described_recipe)
  }

  context 'Include various recipes' do
   
    it 'Should converge' do
      chef_run.converge(described_recipe)
      #expect(chef_run).to include_recipe('oeinfra::apt')
    end
  
  end

end
