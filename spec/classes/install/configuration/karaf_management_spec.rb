# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration::karaf_management' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          etc_dir: '/opt/karaf/work/etc/',
          service_name: 'karaf',
          karaf_rmi_registry_host: '127.0.0.1',
          karaf_rmi_registry_port: 1099,
          karaf_rmi_server_host: '127.0.0.1',
          karaf_rmi_server_port: 44444,
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/org.apache.karaf.management.cfg-rmiRegistryHost').with(setting: 'rmiRegistryHost', value: '127.0.0.1') }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/org.apache.karaf.management.cfg-rmiRegistryPort').with(setting: 'rmiRegistryPort', value: 1099) }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/org.apache.karaf.management.cfg-rmiServerHost').with(setting: 'rmiServerHost', value: '127.0.0.1') }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/org.apache.karaf.management.cfg-rmiServerPort').with(setting: 'rmiServerPort', value: 44444) }
    end
  end
end
