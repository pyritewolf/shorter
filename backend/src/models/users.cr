require "clear"

class Shorter::User
  include Clear::Model
  
  self.table = "users"

  column google_id : String
  column first_name : String

  column id : Int32, primary: true, presence: false

end
