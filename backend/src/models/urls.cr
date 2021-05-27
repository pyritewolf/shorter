require "clear"

class Shorter::URL
  include Clear::Model
  
  self.table = "urls"

  column path : String
  column redirect_to : String

  column id : Int32, primary: true, presence: false

end
