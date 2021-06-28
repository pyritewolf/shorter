require "clear"

class Shorter::URL
  include Clear::Model
  
  self.table = "urls"

  column path : String
  column redirect_to : String
  column user_id : Int32
  column is_private : Bool

  column id : Int32, primary: true, presence: false

end
