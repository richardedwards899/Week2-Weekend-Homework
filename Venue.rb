# require_relative('Guest.rb')

class Venue

  attr_reader :capacity, :entrance_fee, :rooms, :all_guests, :guests_not_in_rooms, :entrance_fees

  attr_writer :entrance_fees

  def initialize(entrance_fee, rooms)
    @entrance_fee = entrance_fee
    @rooms = rooms
    @all_guests = []
    @guests_not_in_rooms = []
    @capacity = calculate_capacity()
    @entrance_fees = 0
  end

  def admit_guest(guest)
    return false if @all_guests.count == @capacity
    if guest.can_afford_entry(@entrance_fee)
      guest.pay_money(self, @entrance_fee)
      @all_guests << guest
      @guests_not_in_rooms << guest
      return true
    end
  end

  def add_guest_to_room(guest, room)
    @guests_not_in_rooms.delete(guest) if room.guests.count < room.capacity
    return room.enter(guest) 
  end

  def drinks_takings
    drinks_in_each_room = []
    @rooms.each() do |room|
      drinks_in_each_room << room.money_taken
    end
    return drinks_in_each_room
  end

  def total_money_spent_on_drink
    total = 0
    @rooms.each() do |room|
      total += room.total_spent_on_drink
    end
    return total
  end

  private

  def calculate_capacity
    capacity = 0
    @rooms.each { |room| capacity += room.capacity }
    return capacity
  end

end
