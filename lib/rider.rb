# require 'pry'
# require 'csv'
# require 'pp'

module RideShare
  class Rider
    attr_reader :name, :id, :phone_num

    def initialize(args)
      @name = args[:name]
      @id = args[:id]
      @phone_num = args[:phone_num]
    end

    # retrieves the list of trip instances that only this rider has taken
    def trips
      RideShare::Trip.find_all_for_rider(@id)
    end

    # retrieves the list of all previous driver instances
    def drivers
    end

    # retrieves all riders from the CSV file
    def self.all
      riders = []
      CSV.foreach('support/riders.csv', headers: true) do |row|
        riders << self.new(id: row['rider_id'].to_i, name: row['name'], phone_num: row['phone_num'])
      end
      return riders
    end

    # finds a specific rider using their numeric ID
    def self.find(rider_id)
      self.all.find {|rider| rider.id == rider_id}
      #binding.pry
      # if no rider is found, returns nil
    end
  end
end
