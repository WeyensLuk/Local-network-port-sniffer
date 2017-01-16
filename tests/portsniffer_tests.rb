require '../src/portscanner'
require 'minitest/autorun'

class TestPortScanner < MiniTest::Test
  def test_that_http_port_is_open
    port_scanner = PortScanner.new('127.0.0.1', 0, 0)
    assert_equal 80, port_scanner.is_port_open(80)
  end

  def test_that_random_unassigned_port_is_closed
    port_scanner = PortScanner.new('127.0.0.1', 0, 0)
    assert_equal nil, port_scanner.is_port_open(42421)
  end

  def test_that_async_scan_returns_open_ports_in_specified_range
    port_scanner = PortScanner.new('127.0.0.1', 70, 80)
    results = []
    results << port_scanner.future.scan
    results.map! {|port_number| port_number.value}
    results.flatten!

    assert_equal results.count, 1
    assert_includes results, 80
  end
end
