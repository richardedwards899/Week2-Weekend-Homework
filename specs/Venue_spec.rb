require('minitest/autorun')
require('minitest/emoji')
require_relative('../Venue.rb')
require_relative('../Room.rb')
require_relative('../Song.rb')
require_relative('../Guest.rb')

class TestVenue < MiniTest::Test

  def setup

    #create rooms
    @room1 = Room.new(1, 20)
    @room2 = Room.new(2, 40)
    @room3 = Room.new(3, 60)
    @room4 = Room.new(4, 80)
    @rooms = [ @room1, @room2, @room3, @room4 ]

    #create songs
    @song1 = Song.new("I Did It My Way", "Frank Sinatra")
    @song2 = Song.new("Jeremy", "Pearl Jam")
    @song3 = Song.new("Cornflake Girl", "Tori Amos")
    @song4 = Song.new("Billie Jean", "Michael Jackson")
    @song5 = Song.new("School's Out", "Alice Cooper")
    @song6 = Song.new("Livin' On a Prayer", "Bon Jovi")
    @song7 = Song.new("Welcome To The Jungle", "Guns 'n Roses")
    @song8 = Song.new("Night Train", "Guns 'n Roses")
    
    #add music to rooms
    @room1.add_song(@song1)
    @room1.add_song(@song2)
    @room2.add_song(@song3)
    @room2.add_song(@song4)
    @room3.add_song(@song5)
    @room3.add_song(@song6)
    @room4.add_song(@song7)
    @room4.add_song(@song8)

    #create venue
    @venue = Venue.new(10, @rooms)

    #create guests
    @guest1 = Guest.new("Fred", 30, @song3)
    @guest2 = Guest.new("Bob", 20, @song7)
    @guest3 = Guest.new("Mavis", 100, @song1)
    @guest4 = Guest.new("Purvis", 25, @song2)
  end

  def test_can_create_venue
    assert_equal(200, @venue.capacity)
    assert_equal(10, @venue.entrance_fee)
    assert_equal(@rooms, @venue.rooms)
    assert_equal([], @venue.all_guests)
    assert_equal([], @venue.guests_not_in_rooms)
  end

  def test_can_admit_guest__successful
    @venue.admit_guest(@guest1)

    assert_equal([@guest1], @venue.all_guests)
    assert_equal([@guest1], @venue.guests_not_in_rooms)
  end

  def test_can_admit_guest_unsuccessful
    guest = Guest.new("Tania", 5, @song1)
    @venue.admit_guest(guest)

    assert_equal([], @venue.all_guests)
  end

  def test_money_deducted_from_guest
    guest = Guest.new("Horace", 15, @song1)
    @venue.admit_guest(guest)

    assert_equal(5, guest.money)
    assert_equal(10, @venue.entrance_fees)
  end

  def test_guests_admitted_to_capacity
    for i in 1..(@venue.capacity)
      guest = Guest.new("Ferdinand", 10, @song1)
      result = @venue.admit_guest(guest)
    end

    assert_equal(200, @venue.all_guests.count)
    assert_equal(true, result)
  end
  
  def test_guests_refused_beyond_capacity
    for i in 1..(@venue.capacity + 1)
      guest = Guest.new("Ferdinand", 10, @song1)
      result = @venue.admit_guest(guest)
    end

    assert_equal(200, @venue.all_guests.count)
    assert_equal(false, result)
  end

  def test_can_add_guest_to_room
    @venue.admit_guest(@guest1)
    @venue.add_guest_to_room(@guest1, @room4)

    assert_equal(1, @room4.guests.count)
    assert_equal(1, @venue.all_guests.count)
    assert_equal(0, @venue.guests_not_in_rooms.count)
  end

  def test_add_guests_to_room__fill_room
    for i in 1..@room1.capacity
      guest = Guest.new("Ferdinand", 20, @song1)
      @venue.admit_guest(guest)
      result = @venue.add_guest_to_room(guest, @room1)
    end    
    assert_equal(true, result)
    assert_equal(20, @room1.guests.count)
    assert_equal(20, @venue.all_guests.count)
    assert_equal(0, @venue.guests_not_in_rooms.count)
  end

  def test_add_guests_to_room__room_full
    for i in 1..(@room1.capacity + 1)
      guest = Guest.new("Ferdinand", 20, @song1)
      @venue.admit_guest(guest)
      result = @venue.add_guest_to_room(guest, @room1)
    end    
    assert_equal(false, result)
    assert_equal(20, @room1.guests.count)
    assert_equal(21, @venue.all_guests.count)
    assert_equal(1, @venue.guests_not_in_rooms.count)
  end

  def test_can_leave_room
    @venue.admit_guest(@guest1)
    @venue.add_guest_to_room(@guest1, @room1)
    @room1.leave(@guest1, @venue)

    assert_equal(1, @venue.all_guests.count)
    assert_equal(0, @room1.guests.count)
    assert_equal(1, @venue.guests_not_in_rooms.count)
  end

  def test_show_money_taken
    @venue.admit_guest(@guest1)
    @venue.add_guest_to_room(@guest1, @room1)
    @guest1.buy_drink(@room1, 5)
    @guest1.buy_drink(@room1, 5)

    assert_equal({ @guest1 => 10 }, @room1.money_taken)

    @venue.admit_guest(@guest2)
    @venue.add_guest_to_room(@guest2, @room1)
    @guest2.buy_drink(@room1, 6)

    expected = { 
      @guest1 => 10, 
      @guest2 => 6 
    }
    assert_equal(expected, @room1.money_taken)

    @venue.admit_guest(@guest3)
    @venue.admit_guest(@guest4)
    @venue.add_guest_to_room(@guest3, @room2)
    @venue.add_guest_to_room(@guest4, @room3)
    @guest3.buy_drink(@room2, 4)
    @guest4.buy_drink(@room3, 7)
    
    @room1.leave(@guest1, @venue)
    @venue.add_guest_to_room(@guest1, @room4)
    @guest1.buy_drink(@room4, 5)

    expected = [
      {
        @guest1 => 10, 
        @guest2 => 6
      }, 
      { @guest3 => 4 },
      { @guest4 => 7 },
      { @guest1 => 5 } 
    ]
    assert_equal(expected, @venue.drinks_takings)

    assert_equal(40, @venue.entrance_fees)
    assert_equal(32, @venue.total_money_spent_on_drink)
  end

end