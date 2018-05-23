module EquitracUtilities
  # User commands for equitrac.
  # @since 0.1.0
  module UserCommands
    # # Generate the add command for a user.
    # # @param user_id [String] The id of the user.
    # # @param init_bal [Float] The initial balance for the account.
    # # @param user_name [String] The name of the user.
    # # @param min_bal [Float] The minimum balance allowed.
    # # @param email [String] The e-mail of the user.
    # # @param dept_name [String] The department the user is in.
    # # @param primary_pin [String] The primary pin code.
    # # @param secondary_pin [String] The secondary pin code.
    # # @param quota [Integer] The print quota.
    # # @param alternate_pin [String] The alternate pin code.
    # # @param home_server [String] The home server.
    # # @param locked [String] The status of the account 0 = unlocked; 1 = locked.
    # # @param location [String] The user location.
    # # @param additional_info [String] Any additional_info information for the account.
    # # @param home_folder [String] The home folder.
    # #
    # # Default params are:
    # #   min_bal: 1
    # #   secondary_pin: ""
    # #   quota: 0
    # #   alternate_pin: 1
    # #   home_server: ""
    # #   locked: 0
    # #   location: ""
    # #   additional_info: 0
    # #   home_folder:""
    # #
    # # @return [String] The equitrac command to add a user.
    # #
    # # Return user information
    # # Can query either one user or All users, for single user use the user_id, for all users use a user_id of All
    # def user_query(attr)
    #   "query ur #{attr[:user_id]}"
    # end
    #
    # # Add user to the system
    # # user id, initial balance, user name, department name, and primary pin required
    # # def user_add(user_id:, init_bal:, user_name:, min_bal: 0.0, email:, dept_name:, primary_pin:, secondary_pin: '""', quota: 0, alternate_pin: '""', home_server: '""', locked: 0, location: '""', additional_info: 0, home_folder: '""')
    # def user_add(attributes)
    #   default = { min_bal: 0.0, secondary_pin: '""',quota: 0,
    #               alternate_pin: '""', home_server: '""', locked: 0,
    #               location: '""', additional_info: 0, home_folder: '""'}
    #   attr = defaults.merge( attributes )
    #
    #   "add ur #{attr[:user_id]} #{attr[:init_bal]} \"#{attr[:user_name]}\" " +
    #   "#{attr[:min_bal]} #{attr[:email]} #{attr[:dept_name]}" +
    #   " #{attr[:primary_pin]} #{attr[:secondary_pin]} #{attr[:quota]}" +
    #   " #{attr[:alternate_pin]} #{attr[:home_server]} #{attr[:locked]}" +
    #   " #{attr[:location]} #{attr[:additional_info]} #{attr[:home_folder]}"
    # end
    #
    # # Lock a user from using the system
    # # user id required
    # def user_lock(attr)
    #   return "lock ur #{attr[:user_id]}"
    # end
    #
    # # Unlock a user allowing system use
    # # user id required
    # def user_unlock(attr)
    #   return "unlock ur #{attr[:user_id]}"
    # end
    #
    # # Modify a user's department
    # # user id and department name required
    # # def user_modify_dept(user_id:, user_name: "!", min_bal: "!", email: "!", dept_name:)
    # def user_modify_dept(attributes)
    #   defaults = {user_name: "!", min_bal: "!", email: "!"}
    #   attr = defaults.merge( attributes )
    #
    #   return "modify ur #{attr[:user_id]} #{attr[:user_name]}" +
    #   " #{attr[:min_bal]} #{attr[:email]} #{attr[:dept_name]}"
    # end
    #
    # # def modifyuser(user_id:, user_name: "!", min_bal: "!", email: "!", dept_name: "!", pimary_pin: "!", secondary_pin: "!", quota: "!", alternate_pin: "!", home_server: "!", locked: "!")
    # #   return "modify ur #{user_id} #{user_name} #{min_bal} #{email} #{dept_name} #{primary_pin} #{secondary_pin} #{quota} #{alternate_pin} #{home_server} #{locked}"
    # # end
    #
    # # module_function :user_query, :user_add, :user_lock, :user_unlock, :user_modify_dept
  end
end
