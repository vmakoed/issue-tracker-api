# frozen_string_literal: true

require 'subroutine/auth'

class ApplicationOp < ::Subroutine::Op
  include Pundit
end
