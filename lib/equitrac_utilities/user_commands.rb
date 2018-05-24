module EquitracUtilities
  module UserCommands
    # Query a user in the system based of user_id
    # To query all users use user_id: All
    # user_id required
    def user_query(attr)
      "query ur #{attr[:user_id]}"
    end
    # Check if a user exists in the system
    # user_id required
    def user_exists?(attr)
      user_query(attr)
    end
    # Process to return true or false when querying if a user user_exists
    def process_user_exists?(test)
      return false if test.include?("Can't find")
      return true  if test.include?("User_ID")
      raise
    end
    # Add user to the system
    # user_id, initial_balance, user_name, department_name, and primary_pin required
    # def user_add(user_id:, init_bal:, user_name:, min_bal: 0.0, email:, dept_name:, primary_pin:, secondary_pin: '""', quota: 0, alternate_pin: '""', home_server: '""', locked: 0, location: '""', additional_info: 0, home_folder: '""')
    def user_add(attributes)
      defaults = { min_bal: 0.0, secondary_pin: '""',quota: 0,
                  alternate_pin: '""', home_server: '""', locked: 0,
                  location: '""', additional_info: 0, home_folder: '""'}
      attr = defaults.merge( attributes )

      "add ur #{attr[:user_id]} #{attr[:init_bal]} \"#{attr[:user_name]}\" " +
      "#{attr[:min_bal]} #{attr[:email]} #{attr[:dept_name]}" +
      " #{attr[:primary_pin]} #{attr[:secondary_pin]} #{attr[:quota]}" +
      " #{attr[:alternate_pin]} #{attr[:home_server]} #{attr[:locked]}" +
      " #{attr[:location]} #{attr[:additional_info]} #{attr[:home_folder]}"
    end
    # Delete a user from the system
    # user_id required
    def user_delete(attr)
      "delete ur #{attr[:user_id]}"
    end
    # Lock a user from using the system
    # user id required
    def user_lock(attr)
      "lock ur #{attr[:user_id]}"
    end
    # # Unlock a user allowing system use
    # # user id required
    def user_unlock(attr)
      "unlock ur #{attr[:user_id]}"
    end
  end
end
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
    # #   return "modify ur #{user_id} #{user_name} #{min_bal} #{email} #{dept_name} #{primary_pin} #{secondary_pin} #{quota} #{alternate_pin} #{home_server} #{locked} <location> <default_bc><additional_info> <home_folder>"
    # # end
    #
  
