# frozen_string_literal: true

module ArclightConstraintsDebug
  def initialize(**kwargs)
    Rails.logger.warn("Arclight::ConstraintsComponent kwargs=#{kwargs.inspect}")
    super
  end
end

Rails.application.config.to_prepare do
  next unless defined?(Arclight::ConstraintsComponent)
  next if Arclight::ConstraintsComponent < ArclightConstraintsDebug

  Arclight::ConstraintsComponent.prepend(ArclightConstraintsDebug)
end
