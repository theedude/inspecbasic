# node = json("/tmp/kitchen_chef_node.json").params
# node = JSON.parse(IO.read('/tmp/kitchen_chef_node.json'))
# let(:node) { JSON.parse(IO.read('/tmp/kitchen_chef_node.json')) }
control 'Basic Networking Configuration' do
  impact 1.0
  title 'Basic Networking Configuration'
  desc 'The instance Network configuration must be ok.'
  # global variable node attributes to access from test
  $node = json('/etc/chef/kitchen_chef_node.json').params

  # Name
  describe command('ping -c 1 `hostname`') do
    its(:exit_status) { should eq(0) }
  end

  describe file('/etc/cloud/cloud.cfg') do
    its('content') { should include('preserve_hostname : true') }
  end
end
