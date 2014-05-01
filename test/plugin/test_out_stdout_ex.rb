require 'fluent/test'

class StdoutExOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::OutputTestDriver.new(Fluent::StdoutExOutput).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal :json, d.instance.output_type
  end

  def test_configure_output_type
    d = create_driver(CONFIG + "\noutput_type json")
    assert_equal :json, d.instance.output_type

    d = create_driver(CONFIG + "\noutput_type hash")
    assert_equal :hash, d.instance.output_type

    assert_raise(Fluent::ConfigError) do
      d = create_driver(CONFIG + "\noutput_type foo")
    end
  end

  def test_emit_json
    d = create_driver(CONFIG + "\noutput_type json")
    time = Time.now
    out = capture_log { d.emit({'test' => 'test'}, time) }
    assert_equal "#{time.localtime} [info]: #{time.localtime} test: {\"test\":\"test\"}\n", out

    # NOTE: Float::NAN is not jsonable
    assert_raise(Yajl::EncodeError) { d.emit({'test' => Float::NAN}, time) }
  end

  def test_emit_hash
    d = create_driver(CONFIG + "\noutput_type hash")
    time = Time.now
    out = capture_log { d.emit({'test' => 'test'}, time) }
    assert_equal "#{time.localtime} [info]: #{time.localtime} test: {\"test\"=>\"test\"}\n", out

    # NOTE: Float::NAN is not jsonable, but hash string can output it.
    out = capture_log { d.emit({'test' => Float::NAN}, time) }
    assert_equal "#{time.localtime} [info]: #{time.localtime} test: {\"test\"=>NaN}\n", out
  end

  def test_emit_ltsv
    d = create_driver(CONFIG + "\nformat ltsv")
    time = Time.now
    out = capture_log { d.emit({'test' => 'test'}, time) }
    assert_equal "current_time:#{time.localtime}\ttime:#{time.localtime}\ttag:test\trecord:{\"test\":\"test\"}\n", out
  end

  private

  # Capture the log output of the block given
  def capture_log(&block)
    tmp = $log
    $log = StringIO.new
    yield
    return $log.string
  ensure
    $log = tmp
  end
end

