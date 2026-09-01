# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration::karaf_shell' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          etc_dir: '/opt/karaf/work/etc/',
          service_name: 'karaf',
          karaf_ssh_host: '127.0.0.1',
          karaf_ssh_port: 8101,
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/org.apache.karaf.shell.cfg-sshHost').with(setting: 'sshHost', value: '127.0.0.1') }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/org.apache.karaf.shell.cfg-sshPort').with(setting: 'sshPort', value: 8101) }
    end
  end
end
