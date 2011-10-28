module Artesia
  class Connection
    attr_accessor :username, :password, :host, :session
  
    def self.expectant_reader(*attributes)
      attributes.each do |attribute|
        (class << self; self; end).send(:define_method, attribute) do
          attribute_value = instance_variable_get("@#{attribute}")
          attribute_value
        end
      end
    end
    expectant_reader :username, :password, :host, :session
  
    def initialize(options = {})
      [:username, :password, :host, :session].each do |attr|
        instance_variable_set "@#{attr}", (options[attr].nil? ? Artesia::Connection.send(attr) : options[attr])
      end
    end
  
    def api
      Artesia::API.new(self)
    end
  end
end