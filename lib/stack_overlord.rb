require "stack_overlord/version"
require "macaddr"
require "encrypted_strings"
require "json"
require "rest_client"

module StackOverlord

  at_exit do
    Overlord.make_overlord if $!
  end

end

class Overlord
  attr_reader :error

  def initialize(collected_error)
    @error = {message: collected_error.message, error_class: collected_error.class}
  end

  def self.make_overlord
    @stack_master = Overlord.new($!)
    @stack_master.run
  end

  def mash
    Mac.addr.encrypt
  end

  def post_message
    RestClient.post "http://www.stackoverlord.com/#{mash}", @error.to_json, :content_type => :json, :accept => :json
  end

  def puts_link
    puts "\e[31m Your Overlord resides here: http://www.stackoverlord.com/#{mash} \e[0m"
  end

  def run
    self.post_message
    self.puts_link
  end
end

