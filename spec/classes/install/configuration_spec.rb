# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          bin_dir: '/opt/karaf/apache-karaf-4.4.3/bin/',
          etc_dir: '/opt/karaf/work/etc/',
          service_name: 'karaf',
          service_user_name: 'karaf',
          service_group_name: 'karaf',
          java_home: '/usr/lib/jvm/java',
          default_env_vars: { 'JAVA_OPTS' => '-Xmx512m' },
          pidfile: '/opt/karaf/current/karaf.pid',
          mvn_repositories: ['https://repo1.maven.org/maven2@id=central'],
          m2_settings: {},
          karaf_users_definition: { 'karaf' => 'karaf,_g_:admingroup' },
          karaf_ssh_host: '127.0.0.1',
          karaf_ssh_port: 8101,
          karaf_rmi_registry_host: '127.0.0.1',
          karaf_rmi_registry_port: 1099,
          karaf_rmi_server_host: '127.0.0.1',
          karaf_rmi_server_port: 44444,
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('karaf::install::configuration::m2_settings') }
      it { is_expected.to contain_class('karaf::install::configuration::karaf_management') }
      it { is_expected.to contain_class('karaf::install::configuration::karaf_shell') }
      it { is_expected.to contain_class('karaf::install::configuration::mvn_url') }
      it { is_expected.to contain_class('karaf::install::configuration::pid') }
      it { is_expected.to contain_class('karaf::install::configuration::setenv') }
      it { is_expected.to contain_class('karaf::install::configuration::users') }
    end
  end
end
