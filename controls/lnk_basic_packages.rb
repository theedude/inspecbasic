control 'Base Packages' do
  impact 1.0
  title 'Base packages'
  desc 'Packages that should be installed on every linux system'

  $node=json('/etc/chef/kitchen_chef_node.json').params

  $node['default']['lnk_basic']['packages_common'].each do |pack|
    describe package(pack) do
      it { should be_installed }
    end
  end
end
