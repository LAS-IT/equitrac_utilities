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
  let( :new_bal)         { {user_id: "tempuser",
                            init_bal: 50.0,
                            email: "test@example.com",
                            user_name: "Temp KID",
                            dept_name: "student",
                            primary_pin: "99999",
                            new_bal: 100.0} }

  context "test query user command" do
    it "gets info on a single user" do
      answer = eq.run(command: :user_query, attributes: valid_id)
      correct = "User_ID"
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
  end

  context "test modify user command" do
    before(:each) do
      eq.run(command: :user_add, attributes: new_attribs)
    end
    after(:each) do
      eq.run(command: :user_delete, attributes: change_attribs)
    end
    it "with valid attributes actually modifies a user" do
      answer = eq.run(command: :user_modify, attributes: change_attribs)
      correct = "MODIFY command processed successfully.\r\n\r\n"
      expect(answer).to eql(correct)
    end
  end

  context "test adjust set user command" do
    before(:each) do
      eq.run(command: :user_add, attributes: new_attribs)
    end
    after(:each) do
      eq.run(command: :user_delete, attributes: change_attribs)
    end
    it "with valid attributes sets a new user balance" do
      answer = eq.run(command: :user_adjust_set, attributes: new_bal)
      correct = "ADJUST command processed successfully.\r\n\r\n"
      expect(answer).to eql(correct)
    end
  end

  context "test unexpected conditions return properly" do
    it "query returns a can't find message on a user who doesn't exist" do
      answer = eq.run(command: :user_query, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "detele returns a can't find message on a user who doesn't exist" do
      answer = eq.run(command: :user_delete, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "lock returns a can't find message on a user who doesn't exist" do
      answer = eq.run(command: :user_lock, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "unlock returns a can't find message on a user who doesn't exist" do
      answer = eq.run(command: :user_unlock, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "modify returns a can't find message on a user who doesn't exist" do
      answer = eq.run(command: :user_modify, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "adjust set returns a can't find message on a user who doesn't exist" do
      answer = eq.run(command: :user_adjust_set, attributes: baduser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "when no user_id present" do
      eq = EquitracUtilities::Connection.new
      nouser_id = {}
      answer = eq.run(command: :user_query, attributes: nouser_id)
      expect(answer).to match('user_id missing')
    end
    it "when user_id ''" do
      eq = EquitracUtilities::Connection.new
      nouser_id = { user_id: '', email: "test@example.com",
                    user_name: "Temp NOID", dept_name: "employee",
                    primary_pin: "99999"}
      answer = eq.run(command: :user_query, attributes: nouser_id)
      expect(answer).to match('user_id empty')
    end
    it "when tries to create a user that already exists" do
      eq = EquitracUtilities::Connection.new
      valid_attribs = { user_id: "lweisbecker", init_bal: 50.0,
                      email: "test@example.com", user_name: "Temp KID",
                      dept_name: "student", primary_pin: "99999"}
      answer = eq.run(command: :user_add, attributes: valid_attribs)
      expect(answer).to match('The user exists')
    end
    it "when tries to execute a non-existent action" do
      eq = EquitracUtilities::Connection.new
      valid_attribs = { user_id: "lweisbecker", init_bal: 50.0,
                      email: "test@example.com", user_name: "Temp KID",
                      dept_name: "student", primary_pin: "99999"}
      answer = eq.run(command: :no_action, attributes: valid_attribs)
      expect(answer).to match('undefined method')
    end
  end
end
