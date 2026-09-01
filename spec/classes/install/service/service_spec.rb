# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::service::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          ensure: 'present',
          instance_root: '/opt/karaf/current/',
          service_name: 'karaf',
          service_user_name: 'karaf',
          service_group_name: 'karaf',
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_file('/etc/init.d/karaf').with(ensure: 'file', mode: '0755') }
      it { is_expected.to contain_service('karaf').with(ensure: 'running', enable: true, hasstatus: true, hasrestart: true) }
    end
  end
end
