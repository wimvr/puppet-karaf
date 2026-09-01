# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::install::user' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          ensure: 'present',
          service_user_name: 'karaf',
          service_user_id: 5000,
          service_group_name: 'karaf',
          service_group_id: 5000,
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_group('karaf').with(ensure: 'present', gid: 5000) }
      it { is_expected.to contain_user('karaf').with(ensure: 'present', uid: 5000, gid: 5000, managehome: true, shell: '/bin/bash') }
    end
  end
end
