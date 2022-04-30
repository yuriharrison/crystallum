require "./spec_helper"


SEED = 0b10101010101_u32
DATA = [
  { 0x00000000, 0x26e379da, "" },
  { 0x248bfa47, 0xbc50e16b, "hello" },
  { 0xc0363e43, 0x16f4492f, "Hello, world!" },
  { 0xd0c5897b, 0x2760da08, "25 Jun 2021 at 07:15:00 PM" },
]

describe Murmur do
  it ".hash32 key" do
    DATA.each do |expected, _, key|
      Murmur.hash32(key).should eq expected
    end
  end

  it ".hash32 key seed" do
    DATA.each do |_, expected, key|
      Murmur.hash32(key, SEED).should eq expected
    end
  end
end
