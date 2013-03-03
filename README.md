# Namespace

Include and Extend your class with Namespace.
Method with the same name in different namespaces.

## Installation

Add this line to your application's Gemfile:

    gem 'namespace'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install namespace

# Usage

## Define namespace with methods.

 * name - [Symbol] - namespace name,

 * block - []Block] with methods

```ruby
  class SomeClass
    include Namespace
    extend  Namespace

    namespace :my_namespace do
      def method_a
        'method_a'
      end
    end
  end

  # For Instance
  SomeClass.new.my_namespace.method_a # => 'method_a'
  # For class
  SomeClass.my_namespace.method_a # => 'method_a'
```
## Outer methods

 All *namespaces* can call outer methods.
```ruby
    class SomeClass
      include Namespace
      extend  Namespace

      def outer
        'outer'
      end

      namespace :my_namespace do
        def method_a
          outer
        end
      end
    end

    SomeClass.new.my_namespace.method_a #=> outer
```

## Take all namespaces for class with `namespaces` method
```ruby
  class SomeClass
    include Namespace
    extend  Namespace

    namespace :a do
    end
    namespace :b do
    end
    namespace :c do
    end
  end

  SomeClass.new.namespaces # => [:a, :b, :c]
```

## Reopen namespace.

 You can reopen any namespace
```ruby
  class SomeClass
    include Namespace
    extend  Namespace

    namespace :a do
      def a; 'a' end
    end
    namespace :a do
      def b; 'b' end
    end
  end

  SomeClass.a.a # => 'a'
  SomeClass.a.b # => 'b'
```

##Namespaces and Inheritance.

 All namespaces from superclass available in subclasses.
```ruby
  class SomeClass
    include Namespace
    extend  Namespace

    namespace :a do
      def a; 'super' end
    end
  end

  class SubSomeClass < SomeClass
    namespace :a do
      def 'a'; 'subclass' end
    end
  end

  SubSomeClass.a.a # => 'subclass'
```

##Namespaces with Rails.

 It can be use for save scopes (for example).
```ruby
  class Model < AR::B
    include Namespace
    extend  Namespace

    scope :lasts, ->{  }
    namespace :my_custom_scopes do
      scope :lasts, ->{  }
    end
  end

  Model.lasts # => return from "lasts" scope
  Model.my_custom_scopes.lasts # => return from namespace scope, "lasts" scope will be override
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
