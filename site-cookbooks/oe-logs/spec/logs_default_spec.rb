require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-logs::default' do

  let(:chef_run) {
    runner(attributes = os)
  }
  
  context "Default does nothing" do
   
    before do
      #Chef::DataBag.stub(:load).with('').and_return(os[:data_bags][:])
      #Chef::EncryptedDataBagItem.stub(:load).with('', '').and_return(os[:data_bags][:][''])
    end
    
    it 'Default' do
      chef_run.converge(described_recipe)
    end
    
  end
  
end

