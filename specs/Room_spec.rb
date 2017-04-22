require('minitest/autorun')
require('minitest/emoji')
require_relative('../Room.rb')
require_relative('../Song.rb')
require_relative('../Guest.rb')
require_relative('../Venue.rb')

class TestRoom < MiniTest::Test

  def setup
    room_number = 1
    capacity = 20
    @room1 = Room.new(room_number, capacity)

    @song1 = Song.new("I Did It My Way", "Frank Sinatra")
    @song2 = Song.new("Jeremy", "Pearl Jam")
    @song3 = Song.new("Cornflake Girl", "Tori Amos")
    @song4 = Song.new("Billie Jean", "Michael Jackson")

    @room1.add_song(@song1)
    @room1.add_song(@song2)
    @room1.add_song(@song3)
    @room1.add_song(@song4)

    @songs_for_room1 = [@song1, @song2, @song3, @song4]

    @guest1 = Guest.new("Mike", 25, Song.new("Jeremy", "Pearl Jam"))
    @guest2 = Guest.new("Reginald", 35, Song.new("Black or While", "Michael Jackson"))

    @venue = Venue.new(10, [@room1])

  end

  def test_can_create_room
    room = Room.new(2, 50)

    assert_equal(2, room.number)
    assert_equal(50, room.capacity)
    assert_equal([], room.guests)
    assert_equal([], room.songs)
    assert_equal({}, room.money_taken)
  end

  def test_can_add_song
    room = Room.new(3, 50)
    room.add_song(@song1)

    assert_equal([@song1], room.songs)
  end

  def test_can_add_multiple_songs
    assert_equal(@songs_for_room1, @room1.songs)
  end

  def test_can_guest_enter_room
    @room1.enter(@guest1)

    assert_equal([@guest1], @room1.guests)
  end

  def test_can_guests_enter_room
    @room1.enter(@guest1)

    assert_equal([@guest1], @room1.guests)
    assert_equal(true, @room1.enter(@guest2))
  end

  #returns true if guest gets in, otherwise returns false
  def test_can_enter_room_if_at_capacity
    room = Room.new(1, 1)
    room.enter(@guest1)

    assert_equal(false, room.enter(@guest2))
  end


  def test_can_leave_room_one_guest
    @room1.enter(@guest1)
    @room1.leave(@guest1, @venue)
     
    assert_equal([], @room1.guests)
    assert_equal([@guest1], @venue.guests_not_in_rooms)
  end

  def test_songlist_contains_song_found
    result = @room1.songlist_contains(@song3)

    assert_equal(true, result)
  end

  def test_songlist_contains_song_not_found
    song = Song.new("Purple Rain","Prince")
    result = @room1.songlist_contains(song)

    assert_equal(false, result)
  end

  def test_calculate_money_spent_on_drink
    @room1.enter(@guest1)
    @room1.enter(@guest2)
    @guest1.buy_drink(@room1, 3)
    @guest2.buy_drink(@room1, 5)

    assert_equal(8, @room1.total_spent_on_drink)
  end

end
