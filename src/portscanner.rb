require 'celluloid/autostart'
require 'socket'

class PortScanner
  include Celluloid

  def initialize(ip, start_port, end_port)
    @ip = ip
    @start_port = start_port
    @end_port = end_port
  end

  def scan
    open_ports = []
    for port_number in @start_port..@end_port
      open_ports << is_port_open(port_number)
    end
    return open_ports.compact
  end

  def is_port_open(port_number)
    begin
      socket = TCPSocket.new(@ip, port_number)
      return port_number
    rescue Errno::ECONNREFUSED, Errno::EACCES, IO::EINPROGRESSWaitWritable
    ensure
      socket.close if socket
    end
  end
end
