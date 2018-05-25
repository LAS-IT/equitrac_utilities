# EquitracUtilities

This is an easy to use ruby wrapper for Equitrac Express using EQCmd.exe.  
So far only user management commands are written. These command are query, add, delete, lock, unlock, and modify.

* Docs found at: https://www.rubydoc.info/gems/equitrac_utilities/


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'equitrac_utilities'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install equitrac_utilities

## Change Log

* **0.1.2** 2018-05-25 - OOPS, missed readme and gemlock

* **0.1.1** 2018-05-25 - Error Handling improvements
  - for missing methods (actions)
  - for missing user_id
  - for user_ids with embedded spaces
  - cleanup for user_id with trailing & leading spaces

* **0.1.0** 2018-05-24 - initial release

## Usage

```ruby
# configure
# Use environmental variables
###################

# connect using
require 'equitrac_utilities/connection'
eq = EquitracUtilities::Connection.new

# sample user information
# the dept_name from the example users must exist in your Equitrac environment
# also the primary_ pin can not be currently in use in your Equitrac environment
users = { primary_pin: 99999,
          user_id: "username1",
          email: "username1@example.com",
          user_name: "FirstName1 LastName1",
          dept_name: 'employee', init_bal: 0.0 }
update_users = { primary_pin: 99999,
          user_id: "username1",
          email: "nameduser1@example.com",
          user_name: "NewName1 OldName1",
          dept_name: 'student', init_bal: 0.0 }

##############
# QUERY USER
# ------------
# query user details
eq.run(command: :user_query, attributes: users)
# => "Can't find the specified account in database."
#
# Confirm existence of user
eq.run(command: :user_exists?, attributes: users)
# => False
#
# CREATE USER
# -------------
# add new user to the equitrac system
eq.run(command: :user_add, attributes: users)
# =>"ADD command processed successfully.\r\n\r\n"
#
# Confirm existence of user
eq.run(command: :user_exists?, attributes: users)
# => True
#
# query user details
eq.run(command: :user_query, attributes: users)
# => "User_ID" "User_Full_Name" "User_Email" "Balance" "Account_Limit" "Account_Status"
#    "username "FirstName1 LastName1" "username1@example.com" "$0.00" "$0.00" "Unlocked"
#
# MODIFY USER ACCOUNT
# --------------------
# modify user account
eq.run(command: :user_modify, attributes: update_users)
# => "MODIFY command processed successfully.\r\n\r\n"
# get user details
eq.run(command: :user_query, attributes: users)
# => "User_ID" "User_Full_Name" "User_Email" "Balance" "Account_Limit" "Account_Status"
#    "username "NewName1 OldName1" "nameduser1@example.com" "$0.00" "$0.00" "Unlocked"
#
# lock user accont
eq.run(command: :user_lock, attributes: users)
# => "LOCK/UNLOCK command processed successfully.\r\n\r\n"
#
# get user details
eq.run(command: :user_query, attributes: users)
# => "User_ID" "User_Full_Name" "User_Email" "Balance" "Account_Limit" "Account_Status"
#    "username "NewName1 OldName1" "nameduser1@example.com" "$0.00" "$0.00" "Locked"
#
# unlock user accont
eq.run(command: :user_unlock, attributes: users)
# => "LOCK/UNLOCK command processed successfully.\r\n\r\n"
#
# get user details
eq.run(command: :user_query, attributes: users)
# => "User_ID" "User_Full_Name" "User_Email" "Balance" "Account_Limit" "Account_Status"
#    "username "NewName1 OldName1" "nameduser1@example.com" "$0.00" "$0.00" "Unocked"
#
# DELETE USER
# ------------
eq.run(command: :user_delete, attributes: users)
# =>"DELETE command processed successfully.\r\n\r\n"
#
# Confirm existence of user
eq.run(command: :user_exists?, attributes: users)
# => False
#


```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/equitrac_utilities. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the EquitracUtilities project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/equitrac_utilities/blob/master/CODE_OF_CONDUCT.md).
