require "./spec_helper"
require "spec/expectations"

abstract class InterfaceX < Repository
  def test_method
    true
  end
end

class A < InterfaceX
  registrate :test_a
end

class B < InterfaceX
  registrate "test_b"

  def initialize(@attr : Bool = false)
  end
end

abstract class InterfaceY < Repository
end

class C < InterfaceY
  registrate :test_a
end


describe Repository do
  it ".Register" do
    Repository::Register.should_not be_nil
  end

  it ".set_default_all" do
    Repository.set_default_all(
      {
        InterfaceX => :test_a,
        InterfaceY => :test_a,
      }
    )
  end

  it ".registrate" do
    A.registrate :test_a_again
  end

  it ".create_for" do
    instance_x = InterfaceX.create
    
    instance_x.should be_a A
    instance_x.test_method.should eq true

    instance_y = InterfaceY.create.should be_a C
    instance_y.should be_a C
    instance_y.responds_to?(:test_method).should eq false
  end

  it ".create_for" do
    instance = InterfaceX.create_for :test_a
    instance.should be_a A

    instance = InterfaceX.create_for :test_a_again
    instance.should be_a A

    instance = InterfaceX.create_for "test_b"
    instance.should be_a B

    instance = InterfaceY.create_for :test_a
    instance.should be_a C
  end

  it ".create_for w/ args" do
    instance = InterfaceX.create_for "test_b", true
    instance.should be_a B
  end
end
