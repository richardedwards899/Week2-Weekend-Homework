require('minitest/autorun')
require('minitest/emoji')
require_relative('../Guest.rb')
require_relative('../Room.rb')
require_relative('../Song.rb')
require_relative('../Venue.rb')

class TestGuest < MiniTest::Test

  def setup
    room_number = 1
    capacity = 20
    @room1 = Room.new(room_number, capacity)

    @song1 = Song.new("I Did It My Way", "Frank Sinatra")
    @song2 = Song.new("Jeremy", "Pearl Jam")
    @song3 = Song.new("Cornflake Girl", "Tori Amos")
    @song4 = Song.new("Billie Jean", "Michael Jackson")
    @song5 = Song.new("School's Out for Summer", "Alice Cooper")

    @room1.add_song(@song1)
    @room1.add_song(@song2)
    @room1.add_song(@song3)
    @room1.add_song(@song4)

    @guest1 = Guest.new("Fred", 30, @song5)
    @guest2 = Guest.new("Bob", 20, @song4)

    @venue = Venue.new(10, [@room1])
  end

  def test_can_create_guest
    fav_song = Song.new("I Want a Dog", "Pet Shop Boys")
    guest = Guest.new("Richard", 100, fav_song)

    assert_equal("Richard", guest.name)
    assert_equal(100, guest.money)
    assert_equal(0, guest.spent)
    assert_equal(fav_song, guest.favourite_song)
  end

  def test_ask_whether_room_has_favourite_song_no
    assert_equal(false, @guest1.ask_whether_room_has_favourite_song(@room1))
  end

  def test_ask_whether_room_has_favourite_song_yes
    assert_equal(true, @guest2.ask_whether_room_has_favourite_song(@room1))
  end

  def test_can_guest_buy_drink_in_room
    @guest1.buy_drink(@room1, 5)

    assert_equal(25, @guest1.money)
    assert_equal(5, @guest1.spent)

    expected = { @guest1 => 5 }
    assert_equal(expected, @room1.money_taken)
  end

  def test_can_buy_two_drinks_in_room
    @guest1.buy_drink(@room1, 5)
    @guest1.buy_drink(@room1, 6)

    assert_equal(19, @guest1.money)
    assert_equal(11, @guest1.spent)

    expected = { @guest1 => 11 }
    assert_equal(expected, @room1.money_taken)
  end

  def test_enough_money_to_buy_drink__yes
    guest = Guest.new("Freya", 5, @song5)
    guest.buy_drink(@room1, 5)

    assert_equal(0, guest.money)
  end

  def test_enough_money_to_buy_drink__no
    guest = Guest.new("Freya", 5, @song5)
    guest.buy_drink(@room1, 6)

    assert_equal(5, guest.money)
  end

  def test_can_afford_entrance_fee
    assert_equal(true, @guest1.can_afford_entry(10))
    assert_equal(false, @guest1.can_afford_entry(50))
  end

  def test_pay_money
    @guest1.pay_money(@venue, 5)

    assert_equal(25, @guest1.money)
    assert_equal(5, @venue.entrance_fees)
  end
end