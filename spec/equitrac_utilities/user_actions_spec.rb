require "spec_helper"

RSpec.describe EquitracUtilities::UserActions do

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
      expect(answer).to eql(correct)
    end
    it "user_unlock builds the query we expect" do
      answer  = eq.send(:user_unlock, valid_id)
      correct = "unlock ur lweisbecker"
      expect(answer).to eql(correct)
    end
    it "user_modify builds the query we expect" do
      answer  = eq.send(:user_modify, change_attribs)
      correct = "modify ur tempuser \"Temp STAFF\" ! test@example.com employee 99999 ! ! ! ! ! ! ! ! !"
      expect(answer).to eql(correct)
    end
  end
end
