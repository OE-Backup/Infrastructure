
require 'spec_helper'

os = @platforms['Ubuntu 12.04']

describe 'oe-postgresql::server_master' do

  let(:chef_run) {
    runner(attributes = os, environment = os[:environment])
  }
    
  context 'Under normal situations' do

    before do
      chef_run.converge(described_recipe)
    end
    
    it 'Should render postgresql.conf template' do
      expect(chef_run).to render_file(
        "#{os[:postgresql]['prefix']['cfg']}/postgresql.conf"
      )#.with_content()
    end

    it 'Should render pg_hba.conf template' do
      expect(chef_run).to render_file(
        "#{os[:postgresql]['prefix']['cfg']}/pg_hba.conf"
      )#.with_content()
    end

  end

  #context 'Without required attributes' do
  #  pending 'not implemented'
  #end

end

