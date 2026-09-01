require 'facter'

Facter.add(:karaf) do
  setcode do
    client = '/opt/karaf/current/bin/client'
    next { instances: {} } unless File.executable?(client)

    output = Facter::Core::Execution.execute("#{client} instance:list", on_fail: :silent)
    lines = output.to_s.lines.map(&:strip)
    header = lines.find { |line| line.include?('State') && line.include?('Name') }

    if header.nil?
      { instances: {} }
    else
      columns = header.split('|').map(&:strip)
      state_index = columns.index('State')
      name_index = columns.index('Name')

      if state_index.nil? || name_index.nil?
        { instances: {} }
      else
        instances = lines.each_with_object({}) do |line, parsed_instances|
          next if line.empty? || line == header || !line.include?('|')

          values = line.split('|').map(&:strip)
          next if values.length <= [state_index, name_index].max
          next if values[state_index].empty? || values[name_index].empty?

          parsed_instances[values[name_index]] = values[state_index]
        end

        { instances: instances }
      end
    end
  end
end