# frozen_string_literal: true

require_relative "daydream/version"

require "rutie"


module Daydream
  class Error < StandardError; end

  Rutie.new(:dream).init 'Init_dream', __dir__
end
