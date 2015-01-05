
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::sysctl' do

  let(:chef_run) {
    runner(attributes = os)
  }
    
  context 'Under normal conditions' do

    before do
      #Chef::DataBag.stub(:load).with(os[:data_bags])
      #Chef::DataBagItem.stub(:load).with( # , # ).and_return(dbi)
    end
    
    it 'Should create a sysctl file' do
      chef_run.converge(described_recipe)
      
      cnt = ''
      os[:postgresql]['sysctl']['attrs'].map { |k,v| cnt <<= "#{k} = #{v}\n" }

      expect(chef_run).to create_file(os[:postgresql]['sysctl']['cfg']).with_content(
        /#{cnt}/
      )
      # TODO
      #expect(chef_run).to run_execute('postgresql-sysctl').with(action: :nothing)
    end

  end

  #context 'With missing attributes' do
  #  pending 'TODO'
  #end
  
end

