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
        expect(client_resource[:creates]).to eq("/opt/karaf/apache-karaf-4.4.11/instances/#{title}/")
      end

      context 'with instance settings' do
        let(:params) do
          {
            ssh_host: '0.0.0.0',
            ssh_port: 8222,
            rmi_registry_host: '0.0.0.0',
            rmi_registry_port: 1199,
            rmi_server_host: '0.0.0.0',
            rmi_server_port: 44445,
            karaf_users_definition: { 'admin' => 'secret,admin' },
            config: { 'service.pid' => 'example' },
            mvn_repositories: ['https://repo.example.test/maven2@id=example'],
            repositories: { 'example' => 'mvn:example/features/1.0/xml/features' },
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_ini_setting("karaf instance #{title} sshHost").with(value: '0.0.0.0') }
        it { is_expected.to contain_ini_setting("karaf instance #{title} sshPort").with(value: 8222) }
        it { is_expected.to contain_ini_setting("karaf instance #{title} rmiRegistryHost").with(value: '0.0.0.0') }
        it { is_expected.to contain_ini_setting("karaf instance #{title} rmiRegistryPort").with(value: 1199) }
        it { is_expected.to contain_ini_setting("karaf instance #{title} rmiServerHost").with(value: '0.0.0.0') }
        it { is_expected.to contain_ini_setting("karaf instance #{title} rmiServerPort").with(value: 44445) }
        it { is_expected.to contain_ini_setting("karaf instance #{title} config service.pid").with(value: 'example') }
        it { is_expected.to contain_file("/opt/karaf/apache-karaf-4.4.11/instances/#{title}/etc/users.properties").with(content: %r{admin = secret,admin}) }
        it { is_expected.to contain_file("/opt/karaf/apache-karaf-4.4.11/instances/#{title}/etc/org.ops4j.pax.url.mvn.cfg").with(content: %r{repo\.example\.test}) }
        it { is_expected.to contain_ini_setting("karaf instance #{title} repository example").with(value: 'mvn:example/features/1.0/xml/features') }
      end

      context 'when absent' do
        let(:params) { { ensure: 'absent' } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_karaf__client("instance:destroy #{title}").with(onlyif: %r{/usr/bin/test -d}) }
        it { is_expected.not_to contain_karaf__client("instance:create #{title}") }
      end

      context 'with a features repository' do
        let(:params) { { features_repository: 'mvn:example/features/1.0/xml/features' } }

        it { is_expected.to contain_exec("karaf instance #{title} featuresRepositories preserve default").with(onlyif: %r{featuresRepositories = }) }
        it { is_expected.to contain_exec("karaf instance #{title} featuresRepositories").with(unless: %r{featuresRepositories = }) }
      end

      context 'with boot features' do
        let(:params) { { features_boot: 'integration.hub.adapters.forward.email.attachment.to.ftp' } }

        it { is_expected.to contain_exec("karaf instance #{title} featuresBoot preserve default").with(onlyif: %r{featuresBoot = }) }
        it { is_expected.to contain_exec("karaf instance #{title} featuresBoot").with(unless: %r{featuresBoot = }) }
      end

      context 'with state started' do
        let(:facts) { os_facts.merge('karaf' => { 'instances' => { title => 'Stopped' } }) }
        let(:params) { { state: 'started' } }

        it { is_expected.to contain_karaf__client("instance:start #{title}").with(parameters: ['instance:start', title]) }
        it { is_expected.not_to contain_karaf__client("instance:stop #{title}") }
      end

      context 'with state stopped' do
        let(:facts) { os_facts.merge('karaf' => { 'instances' => { title => 'Started' } }) }
        let(:params) { { state: 'stopped' } }

        it { is_expected.to contain_karaf__client("instance:stop #{title}").with(parameters: ['instance:stop', title]) }
        it { is_expected.not_to contain_karaf__client("instance:start #{title}") }
      end

      context 'when the instance already has the requested state' do
        let(:facts) { os_facts.merge('karaf' => { 'instances' => { title => 'Started' } }) }
        let(:params) { { state: 'started' } }

        it { is_expected.not_to contain_karaf__client("instance:start #{title}") }
        it { is_expected.not_to contain_karaf__client("instance:stop #{title}") }
      end
    end
  end
end

