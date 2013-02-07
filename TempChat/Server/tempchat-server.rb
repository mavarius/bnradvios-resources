#!/usr/bin/ruby
#
# Socket test

require 'socket'

# Read test:
# this will read and print everything from port 8080
# print TCPSocket.open("127.0.0.1", 8080).read

# Server test
# Open server on port 8081
server = TCPServer.new 8081
loop do
  Thread.start(server.accept) do |client|
    client.puts "Hi from Ruby"
    client.close
  end
end

