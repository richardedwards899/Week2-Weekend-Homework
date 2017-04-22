require('minitest/autorun')
require('minitest/emoji')
require_relative('../Song.rb')

class TestSong < MiniTest::Test

  def test_can_create_song
     song = Song.new("I Want a Dog", "Pet Shop Boys")

     assert_equal("I Want a Dog", song.title)
     assert_equal("Pet Shop Boys", song.artist)  
  end
end

