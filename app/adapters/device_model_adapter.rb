# frozen_string_literal: true

class DeviceModelAdapter
  attr_reader :store

  def initialize(store = ::Device)
    @store = store
  end

  def create(params)
    store.create(params)
  end

  def find_by_token(token)
    decoded = JsonWebToken.decode(token)
    store.find(decoded[:id]) unless decoded.nil?
  end
end
