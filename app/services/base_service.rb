# frozen_string_literal: true

class BaseService
  attr_reader :params

  def self.perform(params = {})
    new(params).call
  end

  def initialize(params = {})
    @params = params
  end
end
