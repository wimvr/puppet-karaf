# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration::users' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          etc_dir: '/opt/karaf/apache-karaf-4.4.11/etc/',
          service_name: 'karaf',
          karaf_users_definition: {
            '_g_\\:admingroup' => 'group,admin,manager,viewer,systembundles,ssh',
            'karaf' => 'karaf,_g_:admingroup',
          },
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_file('/opt/karaf/apache-karaf-4.4.11/etc/users.properties').with(content: %r{karaf = karaf,_g_:admingroup}) }
      it { is_expected.to contain_file('/opt/karaf/apache-karaf-4.4.11/etc/users.properties').with(content: %r{_g_\\:admingroup = group,admin,manager,viewer,systembundles,ssh}) }
    end
  end
end
