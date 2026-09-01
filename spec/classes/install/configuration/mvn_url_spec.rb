# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration::mvn_url' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          etc_dir: '/opt/karaf/work/etc/',
          service_name: 'karaf',
          service_user_name: 'karaf',
          service_group_name: 'karaf',
          mvn_repositories: ['https://repo1.maven.org/maven2@id=central'],
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_file('/opt/karaf/work/etc/org.ops4j.pax.url.mvn.cfg').with(owner: 'karaf', group: 'karaf') }
    end
  end
end
