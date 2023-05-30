# frozen_string_literal: true

class ReadingDummy
  attr_reader :id, :serial_number, :firmware_version

  def initialize(attr)
    @id = attr[:id]
    @temperature = attr[:temperature]
    @humidity = attr[:humidity]
    @co_level = attr[:co_level]
    @health = attr[:health]
    @recorded_at = attr[:recorded_at]
  end

  def valid?; end

  def errors; end
end
