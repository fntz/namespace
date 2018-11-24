require 'spec_helper'

class Object
  include Namespace
  extend  Namespace
end

describe Namespace do

  context "Base" do

    before(:each) do
      class A

        def self.outer
          'class outer'
        end

        def outer
          'instance outer'
        end

        def self.z
          'from class'
        end
        def z
          'from instance'
        end
        namespace :a do
          def z
            'from namespace @a'
          end
          def out
            outer
          end
        end
        namespace :b do
          def z
            'from namespace @b'
          end
        end
      end
    end

    it "have namespaces for instance" do
      A.new.a.z.should == 'from namespace @a'
      A.new.b.z.should == 'from namespace @b'
      A.new.z.should   == 'from instance'
    end

    it "have namespaces for class" do
      A.a.z.should == 'from namespace @a'
      A.b.z.should == 'from namespace @b'
      A.z.should   == 'from class'
    end

    it "call method from outer" do
      A.new.a.out.should == 'instance outer'
      A.a.out.should     == 'class outer'
    end
  end

  context "Exceptions" do

    before(:each) do
      class B
        namespace :a do
        end
        namespace :b do
        end
      end

    end

    it "raise error when method not found" do
      expect { B.new.a.no_method }.to raise_error(NoMethodError)
    end

    it "raise error when called method is namespace" do
      expect { B.new.a.b  }.to raise_error(NoMethodError)
    end

    it "raise error when method exist" do
      expect do
        class C
          def a
          end
          namespace :a do
          end
        end.to raise_error(MethodExist)
      end
    end

    it "not raise error when reopen namespace" do
      expect do
        class Z
          namespace :a do end
          namespace :a do end
        end.to_not raise_error
      end
    end
  end

  context "Helpers" do
    before (:each) do
      class D
        namespace :a do
          def a; end
          def b; end
          def c; end
        end
        namespace :b do
          def a; '@bnamespace' end
        end
        namespace :c do
        end

        nalias 'z', 'b.a'
      end
    end

    it "return all namespaces with #namespaces method" do
      D.new.namespaces.should == [:a, :b, :c]
      D.namespaces.should     == [:a, :b, :c]
    end

    it "create aliases for namespaces #nalias method" do
      D.new.z.should == '@bnamespace'
      D.z.should     == '@bnamespace'
    end

    it "return all method from namespace" do
      D.a.nmethods.should    =~ [:a, :b, :c]
      D.b.nmethods.should    eq [:a]
      D.new.a.nmethods.should =~ [:a, :b, :c]
      D.new.b.nmethods.should    eq [:a]
    end
  end

  context "Reopen" do
    before(:each) do
      class E
        namespace :a do
          def a; end
        end
        namespace :a do
          def b; end
        end
      end
    end

    it "reopen namespace" do
      E.new.a.nmethods.should == [:a, :b]
      E.namespaces.should     == [:a]
    end
  end

  context "Inheritance" do
    before(:each) do
      class F
        namespace :a do
          def a; 'a' end
          def b; 'b' end
        end

        def z; 'z' end
      end

      class G < F
        namespace :a do
          def b; 'G class a-namespace' end
          def c; 'c' end
        end
        namespace :b do
          def c; z end
        end

        nalias 'd', 'a.a'
      end
    end

    it "namespace in subclasses" do
      G.new.a.a.should == 'a'
      G.new.a.b.should == 'G class a-namespace'
      G.namespaces.should == [:a, :b]
      F.namespaces.should == [:a]
      G.new.b.c.should == 'z'
      G.new.d.should == 'a'
    end
  end
end
