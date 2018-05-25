module EquitracUtilities

  # @note Equitrac Administration Guide - https://download.equitrac.com/271828/EE5.6/Docs/Administration_Guide.pdf
  module UserActions

    # Get Equitrac User Info
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_query(attr)
      "query ur #{attr[:user_id]}"
    end

    # Query to test if user exists in Equitrac System
    # @note This required post-answer_post_processing
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_exists?(attr)
      user_query(attr)
    end

    # Process to test if user exists in Equitrac System
    #
    # @param test [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [Boolean] True or False depending on if the user was found or not
    def process_user_exists?(test)
      return false if test.include?("Can't find")
      return true  if test.include?("User_ID")
      raise
    end

    # Add a user to the system
    # @note user_id, initial_balance, user_name, department_name, and primary_pin required
    #
    # @param attributes [Hash] this attribute MUST include { user_id: "userid", init_bal: 0, username: "Test USER", dept_name: "Testdept", primary_pin: "99999"}
    # @return [String] Formatted for EQCmd.exe command execution
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

    # Process to delete a user from the Equitrac System
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_delete(attr)
      "delete ur #{attr[:user_id]}"
    end

    # Process to lock a user in the Equitrac System
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_lock(attr)
      "lock ur #{attr[:user_id]}"
    end

    # Process to unlock a user in the Equitrac System
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_unlock(attr)
      "unlock ur #{attr[:user_id]}"
    end

    # Process to lock a user in the Equitrac System
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_modify(attributes)
      defaults = {user_name: "!", min_bal: "!",
                  email: "!", dept_name: "!", pimary_pin: "!",
                  secondary_pin: "!", quota: "!", alternate_pin: "!",
                  home_server: "!", locked: "!", location: "!",
                  default_bc: "!", additional_info: "!", home_folder: "!"}
      attr = defaults.merge( attributes )
      "modify ur #{attr[:user_id]} \"#{attr[:user_name]}\" #{attr[:min_bal]}" +
      " #{attr[:email]} #{attr[:dept_name]} #{attr[:primary_pin]}" +
      " #{attr[:secondary_pin]} #{attr[:quota]} #{attr[:alternate_pin]}" +
      " #{attr[:home_server]} #{attr[:locked]} #{attr[:location]}" +
      " #{attr[:default_bc]} #{attr[:additional_info]} #{attr[:home_folder]}"
    end
  end
end
