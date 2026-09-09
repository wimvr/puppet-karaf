require 'facter'
require 'etc'

def karaf_rsa_public_key
  service_files = Dir['/etc/systemd/system/*.service'] +
                  Dir['/usr/lib/systemd/system/*.service'] +
                  Dir['/etc/init.d/*']
  service_files.sort_by! { |service_file| File.basename(service_file) == 'karaf.service' ? 0 : 1 }

  service_user = service_files.filter_map do |service_file|
    next unless File.file?(service_file)

    content = File.read(service_file)
    next unless content.match?(%r{(?:ExecStart=.*(?:/karaf/|/apache-karaf/).*?/bin/start|KARAF_ROOT=)})

    content[/^User=(\S+)$/, 1] || content[/^KARAF_USER=(\S+)$/, 1]
  end.first || 'karaf'

  home_dir = Etc.getpwnam(service_user).dir
  public_key = File.join(home_dir, '.ssh', 'id_rsa.pub')

  key = File.read(public_key).strip if File.file?(public_key)
  key.split(' ')[1] if key&.start_with?('ssh-rsa ')
rescue ArgumentError, Errno::ENOENT, Errno::EACCES
  nil
end

Facter.add(:karaf) do
  setcode do
    facts = {}
    rsa_public_key = karaf_rsa_public_key
    facts['rsa.pub'] = rsa_public_key unless rsa_public_key.nil?
    client = '/opt/karaf/current/bin/client'
    next facts.merge(instances: {}) unless File.executable?(client)

    output = Facter::Core::Execution.execute("#{client} instance:list", on_fail: :silent)
    lines = output.to_s.lines.map(&:strip)
    header = lines.find { |line| line.include?('State') && line.include?('Name') }

    if header.nil?
      facts.merge(instances: {})
    else
      columns = header.split('|').map(&:strip)
      state_index = columns.index('State')
      name_index = columns.index('Name')

      if state_index.nil? || name_index.nil?
        facts.merge(instances: {})
      else
        instances = lines.each_with_object({}) do |line, parsed_instances|
          next if line.empty? || line == header || !line.include?('|')

          values = line.split('|').map(&:strip)
          next if values.length <= [state_index, name_index].max
          next if values[state_index].empty? || values[name_index].empty?

          parsed_instances[values[name_index]] = values[state_index]
        end

        facts.merge(instances: instances)
      end
    end
  end
end