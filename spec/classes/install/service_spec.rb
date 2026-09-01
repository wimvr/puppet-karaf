# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          ensure: 'present',
          instance_root: '/opt/karaf/current/',
          service_provider: 'systemd',
          service_name: 'karaf',
          service_user_name: 'karaf',
          service_group_name: 'karaf',
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('karaf::install::service::systemd') }
    end
  end
end
