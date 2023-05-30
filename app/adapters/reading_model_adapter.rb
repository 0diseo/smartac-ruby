# frozen_string_literal: true

class ReadingModelAdapter
  attr_reader :store

  def initialize(store = ::Reading)
    @store = store
  end

  def create(params)
    store.create(params)
  end

  def order_by_day_average(readings, param)
    readings.group_by_day(:recorded_at, format: '%y-%m-%d').average(param)
  end
end
