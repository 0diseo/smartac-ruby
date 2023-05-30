# frozen_string_literal: true

class Reading < ApplicationRecord
  CO_LIMIT = 9
  belongs_to :device

  acts_as_notifiable :users,
                     targets: proc { User.all },
                     notifiable_path: :device_notifiable_path

  after_create :raise_alarms, if: proc { trigger_alarm? }

  def device_notifiable_path
    device_path(device)
  end

  private

  def trigger_alarm?
    co_triggered? || health_triggered?
  end

  def raise_alarms
    notify :users, key: 'device.co_over_limit' if co_triggered?
    notify :users, key: "device.#{health}" if health_triggered?
  end

  def co_triggered?
    co_level.present? && co_level > CO_LIMIT
  end

  def health_triggered?
    %w[needs_service needs_new_filter gas_leak].include?(health)
  end
end
