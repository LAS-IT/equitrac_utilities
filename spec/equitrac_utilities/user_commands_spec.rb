require "spec_helper"

RSpec.describe EquitracUtilities::UserCommands do

  let!(:eq)             { EquitracUtilities::Connection.new }
  let( :valid_id)       { {user_id: "lweisbecker"} }
  let( :notuser_id)     { {user_id: "notuser"} }
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



  context "unit tests" do
    it "user_query builds the query we expect" do
      # answer = eq.user_query(valid_id)
      answer = eq.send(:user_query, valid_id)
      correct = 'query ur lweisbecker'
      expect(answer).to eql(correct)
    end
    it "user_add builds the query we expect" do
      # start   = eq.run(command: :user_exists?, attributes: new_attribs)
      # expect(start).to be_falsey
      answer  = eq.send(:user_add, new_attribs)
      correct = "add ur tempuser 50.0 \"Temp KID\" 0.0 test@example.com student 99999 \"\" 0 \"\" \"\" 0 \"\" 0 \"\""
      expect(answer).to eql(correct)
    end
    it "user_delete builds the query expect" do
      # start   = eq.run(command: :user_exists?, attributes: new_attribs)
      # expect(start).to be_truthy
      answer  = eq.send(:user_delete, new_attribs)
      correct ="delete ur tempuser"
      expect(answer).to eql(correct)
    end
    it "user_lock builds the query we expect" do
      answer  = eq.send(:user_lock, valid_id)
      correct = "lock ur lweisbecker"
    end
    it "user_unlock builds the query we expect" do
      answer  = eq.send(:user_unlock, valid_id)
      correct = "unlock ur lweisbecker"
    end
    xit "user_modify builds the query we expect" do
      answer  = eq.send(:user_modify, change_attribs)
      correct = "modify ur lweisbecker"
    end
  end

  context "test query user command" do
    it "gets info on a single user" do
      answer = eq.run(command: :user_query, attributes: valid_id)
      correct = "User_ID"
      expect(answer).to match(correct)
    end
    it "does not work  on a user who doesn't exist" do
      answer = eq.run(command: :user_query, attributes: notuser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "returns an error with no user_id"
  end

  context "test if a user exists" do
    it "for a user who exists" do
      answer = eq.run(command: :user_exists?, attributes: valid_id)
      puts "who exists rspec answer"
      pp answer
      expect(answer).to be_truthy
    end
    it "for a user who doesn't exist" do
      puts "missing user rspec answer"
      answer = eq.run(command: :user_exists?, attributes: notuser_id)
      pp answer
      expect(answer).to be_falsey
    end
    it "returns an error with no user_id"
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
    it "returns an error with no user_id"
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
    it "returns an error with no user_id"
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
      answer = eq.run(command: :user_lock, attributes: notuser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "returns an error with no user_id"
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
      answer = eq.run(command: :user_unlock, attributes: notuser_id)
      correct = "Can't find the specified account in database."
      expect(answer).to match(correct)
    end
    it "returns an error with no user_id"
  end
  #
  # context "test unlock user command" do
  #   it "gets info on a single user" do
  #     answer = eq.run(command: :user_unlock, attributes: valid_id)
  #     correct = "User_ID"
  #     expect(answer).to match(correct)
  #   end
  #   it "does not work  on a user who doesn't exist" do
  #     answer = eq.run(command: :user_unlock, attributes: notuser_id)
  #     correct = "Can't find the specified account in database."
  #     expect(answer).to match(correct)
  #   end
  #   it "returns an error with no user_id"
  # end

  # context "when user_id not included" do
  #   it "raises an error"
  # end
  #
  # context "test successful user creation" do
  #   it "with vailid attributes"
  # end
  # context "test failing user creation" do
  #   it "with an invalid user id (has a space)"
  #   it "with an existing user"
  #   it "with no username"
  #   it "with no group"
  # end
  #
  # context "test successful user modification" do
  #   it "with vailid attributes"
  # end
  # context "test failing user modification" do
  # it "with an invalid user id (has a space)"
  #   it "with an non-existing user"
  #   it "with no username"
  #   it "with no group"
  # end


end
