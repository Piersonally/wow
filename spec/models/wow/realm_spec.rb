require 'spec_helper'

describe Wow::Realm do
  describe "validation" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :slug }
  end
end
