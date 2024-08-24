# frozen_string_literal: true

class ApplicationService
  class << self
    def call(**args)
      new(**args).call
    end
  end

  private_class_method :new
end
