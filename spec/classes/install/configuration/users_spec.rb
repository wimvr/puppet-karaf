# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration::users' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          etc_dir: '/opt/karaf/work/etc/',
          service_name: 'karaf',
          karaf_users_definition: {
            '_g_\\:admingroup' => 'group,admin,manager,viewer,systembundles,ssh',
            'karaf' => 'karaf,_g_:admingroup',
          },
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/users.properties-_g_\\:admingroup').with(setting: '_g_\\:admingroup', value: 'group,admin,manager,viewer,systembundles,ssh') }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/users.properties-karaf').with(setting: 'karaf', value: 'karaf,_g_:admingroup') }
    end
  end
end
