# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration::setenv' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          bin_dir: '/opt/karaf/apache-karaf-4.4.3/bin/',
          service_name: 'karaf',
          java_home: '/usr/lib/jvm/java',
          default_env_vars: { 'JAVA_OPTS' => '-Xmx512m' },
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_file_line('/opt/karaf/apache-karaf-4.4.3/bin/setenv-JAVA_HOME').with(path: '/opt/karaf/apache-karaf-4.4.3/bin/setenv', line: 'export JAVA_HOME="/usr/lib/jvm/java"', match: '^export JAVA_HOME=') }
      it { is_expected.to contain_file_line('/opt/karaf/apache-karaf-4.4.3/bin/setenv-JAVA_OPTS').with(path: '/opt/karaf/apache-karaf-4.4.3/bin/setenv', line: 'export JAVA_OPTS=-Xmx512m', match: '^export JAVA_OPTS=') }
    end
  end
end
