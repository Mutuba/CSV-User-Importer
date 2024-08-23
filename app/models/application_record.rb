# frozen_string_literal: true

# Every active record table inherits from this class
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
