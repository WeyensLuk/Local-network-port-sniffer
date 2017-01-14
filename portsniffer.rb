require 'socket'

puts 'Please provide an IP to probe'
ip = gets.chomp
ip = ip.to_s == '' ? '127.0.0.1' : ip

def is_port_open(ip, port_number)
  begin
    socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM)
    raw_port = Socket.sockaddr_in(port_number, ip)
    return socket.connect(raw_port)
  rescue Errno::ECONNREFUSED, Errno::EACCES
    return false
  end
end

for port_number in 1..49151
  if is_port_open(ip, port_number)
    puts "#{port_number} Open"
  end
end
