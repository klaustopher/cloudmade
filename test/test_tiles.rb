$LOAD_PATH.unshift File.join('..', 'lib')
require 'cloudmade'
require 'test/unit'
require 'test/mock_connection'

class TilesServiceTest < Test::Unit::TestCase #:nodoc: all

  def setup
    @connection = MockConnection.new('FAKE-API-KEY', 'fake-cloudmade.com')
    @tiles = TilesService.new(@connection, 'tile')
  end

  def test_latlon2tilenums
    p = @tiles.latlon2tilenums(11.1, 34.5, 15)
    assert p.lat == 19524
    assert p.lon == 15367
  end

  def test_tilenums2latlon
    p = @tiles.tilenums2latlon(19524, 15367, 15)
    assert p.lat.to_i == 11
    assert p.lon.to_i == 34
  end

  def test_get_tile
    @connection.return_data = "PNG file content"
    png = @tiles.get_tile(11.1, 34.5, 15)
    assert_equal @connection.request, 'http://tile.fake-cloudmade.com/FAKE-API-KEY/1/256/15/19524/15367.png'
    assert png == @connection.return_data
  end
end