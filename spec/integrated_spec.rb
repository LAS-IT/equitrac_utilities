require "spec_helper"

RSpec.describe 'Equitrac Utilities Integration Tests' do

  let!(:eq)             { EquitracUtilities::Connection.new }
  let( :valid_id)       { {user_id: "lweisbecker"} }
  let( :baduser_id)     { {user_id: "notuser"} }
  let( :newuser_id)     { {user_id: "tempuser"} }
  let( :bad_attribs)    { {user_id: "noattr"} }
  let( :new_attribs)    { {user_id: "tempuser",
                            init_bal: 50.0,
                            email: "test@example.com",
                            user_name: "Temp KID",
                            dept_name: "student",
                            primary_pin: "99999"} }
  let( :change_attribs) { {user_id: "tempuser",
                            email: "test@example.com",
                            user_name: "Temp STAFF",
                            dept_name: "employee",
                            primary_pin: "99999"} }
  let( :no_primarypin)   { {user_id: "tempuser",
                            init_bal: 50.0,
                            email: "test@example.com",
                            user_name: "Temp KID",
                            dept_name: "student"} }
  let( :bad_dept)        { {user_id: "tempuser",
                            init_bal: 50.0,
                            email: "test@example.com",
                            user_name: "Temp KID",
                            dept_name: "student",
                            primary_pin: "99999"} }

  context "test query user command" do
    it "gets info on a single user" do
      answer = eq.run(command: :user_query, attributes: valid_id)
      correct = "User_ID"
      expect(answer).to match(correct)
    end
    it "does not work  on a user who doesn't exist" do
      answer = eq.run(command: :user_query, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
  end

  context "test if a user exists" do
    it "for a user who exists" do
      answer = eq.run(command: :user_exists?, attributes: valid_id)
      expect(answer).to be_truthy
    end
    it "for a user who doesn't exist" do
      answer = eq.run(command: :user_exists?, attributes: baduser_id)
      expect(answer).to be_falsey
    end
  end

  context "test successful user creation" do
    after(:each) do
      eq.run(command: :user_delete, attributes: new_attribs)
    end
    it "with valid attributes actually creates a user" do
      start   = eq.run(command: :user_exists?, attributes: new_attribs)
      expect(start).to be_falsey
      answer  = eq.run(command: :user_add, attributes: new_attribs)
      correct = "ADD command processed successfully.\r\n\r\n"
      expect(answer).to eql(correct)
      after   = eq.run(command: :user_exists?, attributes: new_attribs)
      expect(after).to be_truthy
    end
  end

  context "test succuessful user deletion" do
    before(:each) do
      eq.run(command: :user_add, attributes: new_attribs)
    end
    it "with valid attributes actually deletes a user" do
      start   = eq.run(command: :user_exists?, attributes: new_attribs)
      expect(start).to be_truthy
      answer  = eq.run(command: :user_delete, attributes: new_attribs)
      correct = "DELETE command processed successfully.\r\n\r\n"
      expect(answer).to eql(correct)
      after   = eq.run(command: :user_exists?, attributes: new_attribs)
      expect(after).to be_falsey
    end
  end

  context "test lock user command" do
    before(:each) do
      eq.run(command: :user_add, attributes: new_attribs)
    end
    after(:each) do
      eq.run(command: :user_delete, attributes: new_attribs)
    end
    it "with vaild attributes actually locks a user" do
      answer = eq.run(command: :user_lock, attributes: valid_id)
      correct = "LOCK/UNLOCK command processed successfully.\r\n\r\n"
      expect(answer).to eql(correct)
    end
    it "does not work  on a user who doesn't exist" do
      answer = eq.run(command: :user_lock, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
  end

  context "test unlock user command" do
    before(:each) do
      eq.run(command: :user_add, attributes: new_attribs)
    end
    after(:each) do
      eq.run(command: :user_delete, attributes: new_attribs)
    end
    it "with vaild attributes actually unlocks a user" do
      answer = eq.run(command: :user_unlock, attributes: valid_id)
      correct = "LOCK/UNLOCK command processed successfully.\r\n\r\n"
      expect(answer).to eql(correct)
    end
    it "does not work on a user who doesn't exist" do
      answer = eq.run(command: :user_unlock, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
  end

  context "test modify user command" do
    before(:each) do
      eq.run(command: :user_add, attributes: new_attribs)
    end
    after(:each) do
      eq.run(command: :user_delete, attributes: change_attribs)
    end
    it "with vailid attributes actually modifies a user" do
      answer = eq.run(command: :user_modify, attributes: change_attribs)
      correct = "MODIFY command processed successfully.\r\n\r\n"
      expect(answer).to eql(correct)
    end
    it "does not work on a user who doesn't exist" do
      answer = eq.run(command: :user_modify, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
  end
end
