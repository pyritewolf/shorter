require "spec"
require "spec-kemal"

require "../src/main"

def cleanup_test_db()
  Shorter::User.query.to_delete.execute
  Shorter::URL.query.to_delete.execute
end

Spec.before_each { 
  cleanup_test_db()
}
