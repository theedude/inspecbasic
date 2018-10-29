# node = json("/tmp/kitchen_chef_node.json").params
# node = JSON.parse(IO.read('/tmp/kitchen_chef_node.json'))
# let(:node) { JSON.parse(IO.read('/tmp/kitchen_chef_node.json')) }
control 'Basic instance configuration' do
  impact 1.0
  title 'Basic Configuration'
  desc 'The instance should have a basic configuration'
  # global variable node attributes to access from test
  $node = json('/etc/chef/kitchen_chef_node.json').params
  if os.redhat?
    # SELINUX 
    describe command('sestatus') do
      # its(:stdout) { should match(/permissive/) }
      # its(:stdout) { should match(/^(permissive|disabled)$/) }
      its(:stdout) { should match(/(permissive|disabled)/) }
    end
    describe file('/etc/selinux/config') do
      its('content') { should include('SELINUX=disabled') }
    end
  end
  if os.suse?  
  end
  # Swap
  # describe file($node['default']['lnk_basic']['swap_volume']['device']) do
  #  it { should be_block_device }
  # end
  describe bash('expr $(swapon --summary | grep nvme | cut -f 3) / 1024 | cut -c 1,2') do
    # /tmp/kitchen_chef_node.json
    # let(:node) { JSON.parse(IO.read('/tmp/kitchen_chef_node.json')) }
    # let(:node) { json('/tmp/kitchen_chef_node.json').params }
    its(:stdout) { should eq("#{$node['default']['lnk_basic']['swap_volume']['size']}\n") }
    # its(:stdout) { should eq node.value['basic','swap_volume','size'] }
  end

  describe bash("ls -al /etc/localtime | awk '{ print $11}'") do
    its(:stdout) { should match(/#{$node['default']['lnk_basic']['timezone']}/) }
  end

  # ssm agent
  describe processes('amazon-ssm-agent') do
   it { should exist }
  end

end
