# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration::pid' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          etc_dir: '/opt/karaf/work/etc/',
          service_name: 'karaf',
          pidfile: '/opt/karaf/current/karaf.pid',
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_ini_setting('/opt/karaf/work/etc/config.properties-pid').with(setting: 'karaf.pid.file', value: '/opt/karaf/current/karaf.pid') }
    end
  end
end
