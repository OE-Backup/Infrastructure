
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::repmgr' do

  let(:chef_run) {
    runner(attributes = os)
  }
    
  context 'Under normal situations:' do

    before do
      #Chef::DataBag.stub(:load).with(os[:data_bags])
      #Chef::DataBagItem.stub(:load).with( # , # ).and_return(dbi)
      chef_run.converge(described_recipe)
    end
    
    #%w{ bin/repmgr bin/repmgrd lib/repmgr_funcs.so }.each { |bin|
    #  it "Should create binary file #{bin}" do
    #    expect(chef_run).to create_cookbook_file("repmgr/#{bin}")
    #  end
    #}

    #it "Should render repmgr.conf" do
    #  expect(chef_run).to render_file(
    #    "#{os[:repmgr]['prefix']}/repmgr.conf"
    #  ).with_content(/cluster=#{os[:repmgr]['config']['cluster']}/)
    #end

    pending "TODO"
  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end

