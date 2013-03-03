# Include and Extend Namespace in your class.
#
# == Define namespace with methods.
#
# * name - [Symbol] - namespace name,
#
# * block - [Block] with methods/
#
#
#  class SomeClass
#    include Namespace
#    extend  Namespace
#
#    namespace :my_namespace do
#      def method_a
#        'method_a'
#      end
#    end
#  end
#
#  # For Instance
#  SomeClass.new.my_namespace.method_a # => 'method_a'
#  # For class
#  SomeClass.my_namespace.method_a # => 'method_a'
#
# == Outer methods
# All *namespaces* can call outer methods.
#
#    class SomeClass
#      include Namespace
#      extend  Namespace
#
#      def outer
#        'outer'
#      end
#
#      namespace :my_namespace do
#        def method_a
#          outer
#        end
#      end
#    end
#
#    SomeClass.new.my_namespace.method_a #=> outer
#
#
# == Take all namespaces for class with `namespaces` method
#
#  class SomeClass
#    include Namespace
#    extend  Namespace
#
#    namespace :a do
#    end
#    namespace :b do
#    end
#    namespace :c do
#    end
#  end
#
#  SomeClass.new.namespaces # => [:a, :b, :c]
#
#
# ==Reopen namespace.
# You can reopen any namespace
#
#  class SomeClass
#    include Namespace
#    extend  Namespace
#
#    namespace :a do
#      def a; 'a' end
#    end
#    namespace :a do
#      def b; 'b' end
#    end
#  end
#
#  SomeClass.a.a # => 'a'
#  SomeClass.a.b # => 'b'
#
# ==Namespaces and Inheritance.
#
# All namespaces from superclass available in subclasses.
#
#  class SomeClass
#    include Namespace
#    extend  Namespace
#
#    namespace :a do
#      def a; 'super' end
#    end
#  end
#
#  class SubSomeClass < SomeClass
#    namespace :a do
#      def 'a'; 'subclass' end
#    end
#  end
#
#  SubSomeClass.a.a # => 'subclass'
#
#
# == Namespaces and Rails.
# It can be use for save scopes (for example).
#
#  class Model < AR::B
#    include Namespace
#    extend  Namespace
#
#    scope :lasts, ->{  }
#    namespace :my_custom_scopes do
#      scope :lasts, ->{  }
#    end
#  end
#
#  Model.lasts # => return from "lasts" scope
#  Model.my_custom_scopes.lasts # => return from namespace scope, "lasts" scope will be override
#
#
module Namespace
  #
  #
  # == Define namespace with methods.
  #
  # * name - Symbol - namespace name.
  #
  # * block - Blocl with methods
  #
  #
  #  class SomeClass
  #    include Namespace
  #    extend  Namespace
  #
  #    namespace :my_namespace do
  #      def method_a
  #        'method_a'
  #      end
  #    end
  #  end
  #
  #  # For Instance
  #  SomeClass.new.my_namespace.method_a # => 'method_a'
  #  # For class
  #  SomeClass.my_namespace.method_a # => 'method_a'
  #
  def namespace(name, &block)
    namespace_exist?(name)
    m = case self.respond_to?(name)
          when true
            self.send(name).instance_eval &block if block_given?
            self.send(name)
          else
            Module.new do
              instance_eval &block if block_given?
              instance_eval do
                #
                # Return all methods from namespace
                #
                #
                #  class SomeClass
                #    include Namespace
                #    extend  Namespace
                #
                #    namespace :a do
                #      def a; end
                #      def b; end
                #      def c; end
                #    end
                #  end
                #
                #  SomeClass.a.nmethods # => [:a, :b, :c]
                #
                def nmethods
                  methods(false) - [:method_missing, :nmethods]
                end

                def method_missing(method, *args, &block) #:nodoc:
                  raise NoMethodError.new(method) if not @klass.respond_to?(method) or @klass.namespaces.include?(method)
                  @klass.send(method, *args, &block)
                end
              end
            end
        end

    ((@namespaces ||= []) << name).uniq!

    define_namespaces # ->

    %w(define_method define_singleton_method).each do |method|
      send(method, name) do
        klass = self
        m.instance_eval{ @klass = klass }
        m
      end
    end
  end

  #
  # Use for create short alias for namespace.method
  #
  # * m1 - [String] method for alias
  #
  # * m2 - [String] namespace.method
  #
  #  class SomeClass
  #    include Namespace
  #    extend  Namespace
  #
  #    namespace :some_namespace do
  #      def some_method
  #        #....
  #        'hi'
  #      end
  #    end
  #
  #    nalias 'my_method', 'some_namespace.some_method'
  #  end
  #
  #  # Then
  #  SomeClass.new.my_method # => 'hi'
  #
  def nalias(m1, m2)
    %w(define_method define_singleton_method).each do |method|
      send(method, m1) do
        namespace, method = m2.split('.')
        self.send(namespace).send(method)
      end
    end
  end

  private
  #
  # define method for get all `namespaces` for class or class instance
  #
  def define_namespaces #:nodoc:
    unless self.respond_to?(:namespaces)
      send(:define_singleton_method, :namespaces) { @namespaces }
      send(:define_method, :namespaces) { self.class.namespaces }
    end
  end

  def namespace_exist?(name) #:nodoc:
    if self.respond_to?(:namespaces)
      return false if ( self.superclass.respond_to?(:namespaces) and self.superclass.namespaces.include?(name) ) or (self.respond_to?(:namespaces) and self.namespaces.include?(name))
    end
    raise MethodExist.new("Method `#{name}` already exist.") if (self.methods + self.instance_methods).include?(name)
  end
end



