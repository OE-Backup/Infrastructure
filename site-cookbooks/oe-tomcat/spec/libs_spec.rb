require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-tomcat::libs' do

  let(:chef_run) {
    runner(attributes = os)
  }
    
  context '' do

    before do
      #
    end
   
    it 'Should return without jars attribute' do
      chef_run.node.default.unset['tomcat']['jars'] 
      chef_run.converge(described_recipe)
    end

    it "It should add libs" do
      chef_run.node.set['tomcat']['jars'][:remove] = []
      chef_run.converge(described_recipe)
      os[:tomcat]['jars'][:add].each { |f| 
        expect(chef_run).to create_remote_file_if_missing("#{os[:tomcat]['lib_dir']}/#{f[:name]}")
      }
    end

    it "It should remove libs" do
      chef_run.node.set['tomcat']['jars'][:add] = []
      chef_run.converge(described_recipe)
      os[:tomcat]['jars'][:remove].each { |f| 
        expect(chef_run).to delete_file("#{os[:tomcat]['lib_dir']}/#{f}")
      }
    end

    #it "It should raise an exeption on :name missing" do
    #  chef_run.node.set['tomcat']['libs'][:add] = [ { :asd => 'asd' } ]
    #  chef_run.converge(described_recipe)
    #  expect {
    #    chef_run
    #  }.to raise_error()
    #end

  end

end

