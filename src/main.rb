require 'socket'
require './portscanner'

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

def get_service_name(port_number)
  begin
    return Socket.getservbyport(port_number)
  rescue
    return 'Unknown'
  end
end

for port_number in results.select {|port_number| port_number != nil}
  puts "#{port_number} - #{get_service_name(port_number)} - Open"
end

puts 'Done generating!'
