# = Exceptions
#
# This file contains all of the custom exceptions for this app

module Exceptions

  # == Main Error
  #
  # This is the standard error for all ByFireBePurged errors
  #
  # If you raise it like the following example:
  #
  #     raise Exceptions::ByFireBePurgedError, 'Must provide a redirect value'
  #
  # the API will output
  #
  #   {
  #       "error": "Must provide a redirect value"
  #   }
  class ByFireBePurgedError < StandardError; end
end
