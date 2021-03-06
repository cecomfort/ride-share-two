module RideShare
  class Trip
    attr_reader :id, :rider_id, :driver_id, :date, :rating

    def initialize(args)
      # possible that rider did not give a rating
      check_if_valid_rating(args[:rating]) if args[:rating] != nil

      @id = args[:id]
      @driver_id = args[:driver_id]
      @rider_id = args[:rider_id]
      @date = args[:date]
      @rating = args[:rating]
    end

    # retrieves the associated driver instance through the driver ID
    def driver
      Driver.find(@driver_id)
    end

    # retrieves the associated rider instance through the rider ID
    def rider
      Rider.find(@rider_id)
    end

    # retrieve all trips from the CSV file
    def self.all
      trips = []
      CSV.foreach('support/trips.csv', headers: true) do |row|
        trips << self.new(id: row['trip_id'].to_i, driver_id: row['driver_id'].to_i,
          rider_id: row['rider_id'].to_i, date: row['date'],
          rating: row['rating'].to_i)
      end
      return trips
    end

    # find all trip instances for a given driver ID
    def self.find_all_for_driver(driver_id)
      self.all.find_all {|trip| trip.driver_id == driver_id}
    end

    # find all trip instances for a given rider ID
    def self.find_all_for_rider(rider_id)
      self.all.find_all {|trip| trip.rider_id == rider_id}
    end

    private

    def check_if_valid_rating(rating)
      unless (rating.is_a? Integer)
        raise ArgumentError.new("rating must be an int")
      end

      unless rating >= 1 && rating <= 5
        raise InvalidRatingError.new("Rating must be between 1-5, inclusive")
      end
    end
  end
end
