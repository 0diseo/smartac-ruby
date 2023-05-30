# frozen_string_literal: true

module ApplicationHelper
  # rubocop:disable Metrics/MethodLength
  def bootstrap_classes_for_flash(flash_type)
    classes = %w[alert alert-dismissable fade show]

    classes <<  case flash_type
                when 'success'
                  'alert-success'
                when 'error'
                  'alert-danger'
                when 'alert'
                  'alert-warning'
                when 'notice'
                  'alert-info'
                else
                  flash_type.to_s
                end
    classes.join(' ')
  end
  # rubocop:enable Metrics/MethodLength
end
