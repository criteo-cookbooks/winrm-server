require 'spec_helper'

describe 'winrm_config_listener' do
  before do
    allow_any_instance_of(::Chef::Win32::Registry).to receive(:key_exists?).and_return true
    allow_any_instance_of(::Chef::Win32::Registry).to receive(:get_values).and_return [
      { name: 'Port', data: 5895 },
      { name: 'certThumbprint', data: 'AABBCCDDEEFF00112233445566778899' },
      { name: 'hostname', data: 'fake' },
      { name: 'uriprefix', data: 'wsman' },
    ]
    allow_any_instance_of(::Chef::Win32::Registry).to receive(:get_subkeys).and_return []
  end

  describe 'action create' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['winrm_config_listener']).converge('winrm-config-test::configure_listener')
    end

    before do
      stub_command('netsh http show urlacl url=http://+:5985/wsman/ | FindStr http://+:5985/wsman/').and_return true
      stubs_for_provider("winrm_config_listener[configure_listener]") do |provider|
        allow(provider).to receive_shell_out("netsh.exe http show urlacl url=HTTP://+:5985/wsman/")
      end
    end

    it 'creates listener registry key' do
      expect(chef_run).to configure_winrm_config_listener('configure_listener')
      expect(chef_run).to create_registry_key('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Listener\*+HTTP')
    end
  end

  describe 'action delete' do

    let(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['winrm_config_listener']).converge('winrm-config-test::delete_listener')
    end

    it 'deletes listener registry key' do
      expect(chef_run).to delete_winrm_config_listener('delete_listener')
      expect(chef_run).to delete_registry_key('HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WSMAN\Listener\*+HTTPS')
    end
  end
end
