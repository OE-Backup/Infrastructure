require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-tomcat::context' do
  
  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
  
  context 'Default context' do
    
    before do
      Chef::EncryptedDataBagItem.stub(:load).with(
        os[:tomcat]['context']['databag'],
        os[:tomcat]['context']['databag_item'], 
      ).and_return(os[:databags]['some_databag']['item_1'])
      chef_run.converge(described_recipe)
    end
    
    it 'Should render context' do
      expect(chef_run).to render_file("#{chef_run.node['tomcat']['dirs']['config']}/context.xml")
    end
    
  end
  
  #context 'Default context with no parameters' do
  #  
  #  before do
  #    Chef::EncryptedDataBagItem.stub(:load).with(
  #      os[:tomcat]['context']['databag'],
  #      os[:tomcat]['context']['databag_item'], 
  #    ).and_return(os[:databags]['some_databag']['item_1'])
  #    chef_run.node.set['tomcat']['context'] = {}
  #    chef_run.converge(described_recipe)
  #  end
  #  
  #  it 'Should render context' do
  #    expect(chef_run).to render_file("#{chef_run.node['tomcat']['dirs']['config']}/context.xml")
  #  end
  #  
  #end
 
end

