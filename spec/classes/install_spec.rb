# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          ensure: 'present',
          version: '4.4.3',
          rootdir: '/opt/karaf/',
          java_home: '/usr/lib/jvm/java',
          karaf_zip_url: 'https://example.com/apache-karaf-${version}.zip',
          manage_user: true,
          service_user_name: 'karaf',
          service_user_id: 5000,
          service_group_name: 'karaf',
          service_group_id: 5000,
          service_name: 'karaf',
          default_env_vars: { 'JAVA_OPTS' => '-Xmx512m' },
          pidfile: '/opt/karaf/current/karaf.pid',
          service_provider: 'systemd',
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
      it { is_expected.to contain_class('karaf::install::configuration') }
      it { is_expected.to contain_class('karaf::install::service') }
    end
  end
end
