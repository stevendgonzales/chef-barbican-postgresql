require 'spec_helper'

describe 'barbican-postgresql::barbican_db' do
  let(:chef_run) do
    @chef_run = ::ChefSpec::Runner.new
    @chef_run.converge(described_recipe)
  end

  it 'creates barbican_api database' do
    expect(chef_run).to create_postgresql_database('barbican_api').with(
      :connection => {
        :host => 'localhost',
        :port => chef_run.node['postgresql']['config']['port'],
        :username => 'postgres',
        :password => chef_run.node['postgresql']['password']['postgres']
      },
      :action => [:create],
      :retries => chef_run.node['postgresql']['db_actions']['retries'],
      :retry_delay => chef_run.node['postgresql']['db_actions']['retry_delay']
    )
  end

  it 'creates barbican db user' do
    expect(chef_run).to create_database_user('barbican').with(
      :connection => {
        :host => 'localhost',
        :port => chef_run.node['postgresql']['config']['port'],
        :username => 'postgres',
        :password => chef_run.node['postgresql']['password']['postgres']
      },
      :password => chef_run.node['postgresql']['password']['barbican'],
      :action => [:create],
      :retries => chef_run.node['postgresql']['db_actions']['retries'],
      :retry_delay => chef_run.node['postgresql']['db_actions']['retry_delay']
    )
  end

  it 'grants barbican db user all privelages' do
    expect(chef_run).to grant_postgresql_database_user('barbican').with(
      :connection => {
        :host => 'localhost',
        :port => chef_run.node['postgresql']['config']['port'],
        :username => 'postgres',
        :password => chef_run.node['postgresql']['password']['postgres']
      },
      :database_name => 'barbican_api',
      :privileges => [:all],
      :action => [:grant],
      :retries => chef_run.node['postgresql']['db_actions']['retries'],
      :retry_delay => chef_run.node['postgresql']['db_actions']['retry_delay']
    )
  end

end
