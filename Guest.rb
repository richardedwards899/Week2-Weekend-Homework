class Guest

  attr_reader :name, :money, :favourite_song, :spent

  def initialize(name, money, favourite_song)
    @name = name
    @money = money
    @favourite_song = favourite_song
    @spent = 0
  end

  def ask_whether_room_has_favourite_song(room)
    return room.songlist_contains(@favourite_song)
  end

  def buy_drink(room, cost)
    return nil if cost > @money
    @money -= cost
    @spent += cost
    
    if room.money_taken.include?(self)
      room.money_taken[self] += cost      
    else
      room.money_taken[self] = cost
    end
  end

  def can_afford_entry(cost)
    return @money - cost >= 0
  end

  def pay_money(venue, payment)
    @money -= payment
    venue.entrance_fees += payment
    @spent += payment
  end

end