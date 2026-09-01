# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::configuration::m2_settings' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'service { "karaf": }' }
      let(:params) do
        {
          user: 'karaf',
          group: 'karaf',
          m2_settings: {
            'servers' => [{ 'id' => 'central', 'username' => 'user', 'password' => 'pass' }],
            'mirrors' => [{ 'id' => 'mirror', 'name' => 'Mirror', 'url' => 'https://example.com', 'mirrorOf' => '*' }],
          },
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_file('/home/karaf/.m2/').with(ensure: 'directory', owner: 'karaf', group: 'karaf') }
      it { is_expected.to contain_file('/home/karaf/.m2/settings.xml').with(owner: 'karaf', group: 'karaf', mode: '0640') }
    end
  end
end
