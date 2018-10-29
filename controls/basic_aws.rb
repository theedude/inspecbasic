
# node = json("/tmp/kitchen_chef_node.json").params
# node = JSON.parse(IO.read('/tmp/kitchen_chef_node.json'))
# let(:node) { JSON.parse(IO.read('/tmp/kitchen_chef_node.json')) }
control 'Basic AWS configuration' do
  impact 1.0
  title 'Basic AWS Configuration'
  desc 'The instance should be correctly configured in AWS.'

  # global variable node attributes to access from test
  $node=json('/etc/chef/kitchen_chef_node.json').params

  describe command('aws') do
    its(:stderr) { should match(/too few arguments/) }
  end

  instance_id=$node['automatic']['ec2']['instance_id']
  describe aws_ec2_instance(instance_id) do
    it { should be_running }
  end
 
end
