require "./spec_helper.cr"

json_a = %[
  {
    "name": "david",
    "age": 10,
    "friends": [
      {
        "name": "jonathan",
        "age": 20
      },
      {
        "name": "richard",
        "age": 22
      }
    ]
  }
]

json_b = %[
  {
    "name": "david",
    "age": 10,
    "friends": [
      {
        "name": "jonathan",
        "age": 20
      },
      {
        "name": "richard",
        "age": 22
      }
    ]
  }
]

describe JSON::Any do
  it "#diff" do
    JSON.parse(json_a).diff JSON.parse(json_b) do |diff|
      raise "should have no difference"
    end
  end
end
