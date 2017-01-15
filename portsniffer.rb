require 'socket'
require 'celluloid/autostart'

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

puts 'Please provide an IP to probe [127.0.0.1]'
ip = gets.chomp
ip = ip.to_s == '' ? '127.0.0.1' : ip

range = 100
port_number = 1
results = []

until port_number >= 20000
  port_scanner = PortScanner.new(ip, port_number, port_number + range)
  (results << port_scanner.future.scan).flatten!

  port_number += range + 1
end
results.map! {|port_number| port_number.value}
results.flatten!

for port_number in results.select {|port_number| port_number != nil}
  puts "#{port_number} Open"
end

puts 'Done generating!'
