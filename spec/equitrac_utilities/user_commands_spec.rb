require "spec_helper"

RSpec.describe EquitracUtilities::UserCommands do

  let!(:eq)             { EquitracUtilities::Connection.new }
  let( :valid_id)       { {user_id: "lweisbecker"} }
  let( :notuser_id)     { {user_id: "notuser"} }
  let( :newuser_id)     { {user_id: "tempuser"} }
  let( :bad_attribs)    { {user_id: "noattr"} }
  let( :new_attribs)    { {user_id: "tempuser",
                            email: "test@example.com",
                            user_name: "Temp KID",
                            dept_name: "student",
                            primary_pin: "99999"} }
  let( :change_attribs) { {user_id: "tempuser",
                            email: "test@example.com",
                            user_name: "Temp STAFF",
                            dept_name: "employee",
                            primary_pin: "99999"} }

  context "user paramters are correct" do
    it "builds the query we expect" do
      # answer = eq.user_query(valid_id)
      answer = eq.send(:user_query, valid_id)
      correct = 'query ur lweisbecker'
      expect(answer).to eql(correct)
    end
    it "get info on a single user" do
      answer = eq.run(command: :user_query, attributes: valid_id)
      correct = "User_ID"
      expect(answer).to match(correct)
    end
    it "who doesn't exist" do
      answer = eq.run(command: :user_query, attributes: notuser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
  end

  context "test if a user exists" do
    it "who exists" do
      answer = eq.run(command: :user_exists?, attributes: valid_id)
      expect(answer).to be_truthy
    end
    it "who doesn't exist" do
      answer = eq.run(command: :user_exists?, attributes: notuser_id)
      expect(answer).to be_truthy
    end
  end

  context "when user_id not included" do
    it "raises an error"
  end

  context "test successful user creation" do
    it "with vailid attributes"
  end
  context "test failing user creation" do
    it "with an invalid user id (has a space)"
    it "with an existing user"
    it "with no username"
    it "with no group"
  end

  context "test successful user modification" do
    it "with vailid attributes"
  end
  context "test failing user modification" do
  it "with an invalid user id (has a space)"
    it "with an non-existing user"
    it "with no username"
    it "with no group"
  end


end
