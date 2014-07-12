require "spec_helper"

describe Wow::Toon do
  describe "associations" do
    it { should belong_to :user }
  end

  describe "validations" do
    it { should validate_presence_of :realm_id }
    it { should validate_presence_of :name }
  end
end
