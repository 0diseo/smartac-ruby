# frozen_string_literal: true

class DeviceDummy
  attr_reader :id, :serial_number, :firmware_version

  def initialize(attr)
    @id = attr[:id]
    @serial_number = attr[:serial_number]
    @firmware_version = attr[:firmware_version]
  end

  def readings; end
end
