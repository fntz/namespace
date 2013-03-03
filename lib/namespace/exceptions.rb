#
# Raised when Class have method, which used for define namespace
# For Example:
#
#  class SomeClass
#    def some
#    end
#
#    namespace :some do
#    end
#  end
#
# Will be raised MethodExist error.
class MethodExist < Exception
end