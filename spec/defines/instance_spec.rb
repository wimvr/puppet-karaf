# frozen_string_literal: true

require 'spec_helper'

describe 'karaf::instance' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge('karaf' => { 'instances' => [] }) }
      let(:pre_condition) do
        <<-PUPPET
        class { 'karaf':
          remember_ssh_ports => true,
          java_home => '/usr/lib/jvm/java',
          default_env_vars => { 'JAVA_OPTS' => '-Xmx512m' },
        }
        PUPPET
      end

      let(:title) { 'email2ftp-teste2f2' }

      it 'does not embed a Deferred object in the generated instance:create command' do
        client_titles = catalogue.resources.map(&:title).grep(/instance:create/)

        expect(client_titles).not_to be_empty
        expect(client_titles.first).not_to match(/Deferred\(/)
      end

      it 'skips instance:create when the instance directory already exists' do
        client_resource = catalogue.resources.find do |resource|
          resource.type == 'Karaf::Client' && resource.title == "instance:create #{title}"
        end

        expect(client_resource).not_to be_nil
        expect(client_resource[:creates]).to eq("/opt/karaf/work/instances/#{title}/")
      end
    end
  end
end

