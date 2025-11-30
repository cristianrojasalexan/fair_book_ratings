require 'rails_helper'

RSpec.describe User, type: :model do
  it "puede estar baneado o no" do
    user = User.new(banned: true)
    expect(user.banned).to eq(true)
  end
end
