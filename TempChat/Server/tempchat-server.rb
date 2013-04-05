#!/usr/bin/ruby
#
# Socket test

require 'socket'

# Read test:
# this will read and print everything from port 8080
# print TCPSocket.open("127.0.0.1", 8080).read

port = 8081
print "Opening port ", port, "\n"

# Server test
# Open server on port 8081
server = TCPServer.new port
loop do
  Thread.start(server.accept) do |client|
    client.puts "Hi from Ruby"
    sleep(3)
    client.puts "I said hello"
    sleep(3)
    client.puts "Helllloooooooo"
    sleep(3)
    client.puts "CAN YOU HEAR ME?"
    client.close
  end
end

