require "./spec_helper"
require "spec/expectations"

abstract class InterfaceX < Repository
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
  it ".registrate" do
    A.registrate :test_a_again
  end

  it ".create" do
    instance = InterfaceX.create :test_a
    instance.should be_a A

    instance = InterfaceX.create :test_a_again
    instance.should be_a A

    instance = InterfaceX.create "test_b"
    instance.should be_a B

    instance = InterfaceY.create :test_a
    instance.should be_a C
  end

  it ".create w/ args" do
    instance = InterfaceX.create "test_b", true
    instance.should be_a B
  end
end