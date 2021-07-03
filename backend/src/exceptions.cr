require "json"

module Shorter
  class FieldError
    include JSON::Serializable
    property field : String
    property message : String

    def initialize(@field : String, @message : String)
    end
  end

  class HttpError < Exception
    property code, msg, field

    def initialize(@code : Int = 500, @msg : String = "", @field : FieldError? = nil)
      if @code == 401 && @msg == ""
        @msg = "You need to log in to do this!"
      end
      super(msg)
    end

    def initialize(@field : FieldError)
      @code = 422
      @msg = ""
      super(msg)
    end
  end
end
