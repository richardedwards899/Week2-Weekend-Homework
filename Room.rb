class Room

  attr_reader :number, :capacity, :guests, :songs, :money_taken

  def initialize(number, capacity)
    @number = number
    @capacity = capacity
    @guests = []
    @songs = []
    @money_taken = {}
  end

  def add_song(song)
    @songs.push(song)
  end

  def enter(guest)
    if @guests.count < @capacity
      @guests << guest
      return true
    end
    return false
  end

  def leave(guest, venue)
    @guests.delete(guest)
    venue.guests_not_in_rooms << guest
  end

  def songlist_contains(song)
    return @songs.include?(song)
  end

  def total_spent_on_drink
    total = 0
    values = @money_taken.values
    values.each { |value| total += value }
    return total 
  end
end