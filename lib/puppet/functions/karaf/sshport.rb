Puppet::Functions.create_function(:'karaf::sshport') do
  dispatch :sshport do
    required_param 'String', :process
    required_param 'String', :etc_dir
    return_type 'Optional[Integer]'
  end

  def sshport(process, etc_dir)
    basedir = '/var/lib/karaf/sshports'
    return nil unless File.directory?(basedir)

    unless process.match?(/\A[A-Za-z0-9][A-Za-z0-9_.-]*\z/)
      raise ArgumentError, 'process must be a safe filename component'
    end

    config_file = "#{etc_dir}org.apache.karaf.shell.cfg"
    return nil unless File.file?(config_file)

    minimum_port = File.foreach(config_file).filter_map do |line|
      match = line.match(/^\s*sshPort\s*=\s*(\d+)\s*$/)
      match && match[1].to_i
    end.first
    return nil unless minimum_port

    lock_file = File.join(basedir, '.sshport.lock')

    File.open(lock_file, 'w') do |lock|
      lock.flock(File::LOCK_EX)

      port_file = File.join(basedir, "#{process}.port")
      return Integer(File.read(port_file).strip) if File.file?(port_file)

      used_ports = Dir[File.join(basedir, '*.port')].filter_map do |file|
        Integer(File.read(file).strip, 10)
      rescue ArgumentError
        nil
      end
      port = if used_ports.empty?
               minimum_port + 1
             else
               [minimum_port, used_ports.max].max + 1
             end
      File.write(port_file, "#{port}\n")
      port
    end
  end
end
