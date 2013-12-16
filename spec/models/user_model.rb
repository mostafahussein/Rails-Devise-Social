require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  context "FactoryGirl.create" do
    it "should create fake user" do
      expect {
        FactoryGirl.create(:user)
      }.to change{ User.count }.by(1)
    end

    it "email field should not be null or empty" do
      user = FactoryGirl.create(:user)
      user.email.should be
      user.email.should_not be_empty
    end
  end

  context "model" do
    it "should create user" do
      User.create({
        email: Faker::Internet.email, 
        name: "#{Faker::Name.first_name} #{Faker::Name.last_name}", 
        password: "pass123", 
        password_confirmation: "pass123", 
        admin: true
      })
      User.should have(1).record
    end

    it "should not create user with incorrect email" do
      user = User.create({
        email: 'notemail', 
        name: Faker::Internet.user_name, 
        password: "pass123", 
        password_confirmation: "pass123", 
        admin: true
      })
      user.should have(1).error_on(:email)
    end
  end
end