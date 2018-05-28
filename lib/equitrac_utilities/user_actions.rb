module EquitracUtilities

  # @note Equitrac Administration Guide - https://download.equitrac.com/271828/EE5.6/Docs/Administration_Guide.pdf
  module UserActions


    # # Be sure Actions have correct user_id data
    # #
    # # @param action [Symbol] the action to be formatted
    # # @return [String] this attribute MUST include: { user_id: "userid" }
    # def check_user_id(action, attribs)
    #   # attribs[:uid] = attribs[:uid].to_s.strip
    #   attribs[:user_id] = attribs[:user_id]&.strip
    #   answer = send(action, attribs)
    #   raise ArgumentError, "missing user_id"   if attribs[:user_id].nil? or
    #                                               attribs[:user_id].empty?
    #   raise ArgumentError, "user_id has space" if attribs[:user_id].include?(' ')
    #   return answer
    # end

    # Be sure Actions have correct user_id data
    #
    # @param action [Symbol] the action to be formatted
    # @return [String] this attribute MUST include: { user_id: "userid" }
    def check_atrribs(attribs)
      # attribs[:uid] = attribs[:uid].to_s.strip
      attribs[:user_id] = attribs[:user_id]&.strip
      raise ArgumentError, "user_id missing"   if attribs[:user_id].nil?
      raise ArgumentError, "user_id empty"     if attribs[:user_id].empty?
      raise ArgumentError, "user_id has space" if attribs[:user_id].include?(' ')
      return attribs
    end


    # Get Equitrac User Info
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_query(attribs)
      attribs = check_atrribs(attribs)
      "query ur #{attribs[:user_id]}"
    end

    # Query to test if user exists in Equitrac System
    # @note This required post-answer_post_processing
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_exists?(attribs)
      attribs = check_atrribs(attribs)
      user_query(attribs)
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
    def user_add(attribs)
      defaults   = {min_bal: 0.0, secondary_pin: '""',quota: 0,
                    alternate_pin: '""', home_server: '""', locked: 0,
                    location: '""', additional_info: 0, home_folder: '""'}
      attribs = defaults.merge( attribs )

      attribs = check_atrribs(attribs)

      "add ur #{attribs[:user_id]} #{attribs[:init_bal]}" +
      " \"#{attribs[:user_name]}\" #{attribs[:min_bal]}" +
      " #{attribs[:email]} #{attribs[:dept_name]}" +
      " #{attribs[:primary_pin]} #{attribs[:secondary_pin]}" +
      " #{attribs[:quota]} #{attribs[:alternate_pin]}" +
      " #{attribs[:home_server]} #{attribs[:locked]}" +
      " #{attribs[:location]} #{attribs[:additional_info]}" +
      " #{attribs[:home_folder]}"
    end

    # Process to delete a user from the Equitrac System
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_delete(attribs)
      attribs = check_atrribs(attribs)
      "delete ur #{attribs[:user_id]}"
    end

    # Process to lock a user in the Equitrac System
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_lock(attribs)
      attribs = check_atrribs(attribs)
      "lock ur #{attribs[:user_id]}"
    end

    # Process to unlock a user in the Equitrac System
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_unlock(attribs)
      attribs = check_atrribs(attribs)
      "unlock ur #{attribs[:user_id]}"
    end

    # Process to lock a user in the Equitrac System
    #
    # @param attr [Hash] this attribute MUST include: { user_id: "userid" }
    # @return [String] Formatted for EQCmd.exe command execution
    def user_modify(attribs)
      defaults = {user_name: "!", min_bal: "!",
                  email: "!", dept_name: "!", pimary_pin: "!",
                  secondary_pin: "!", quota: "!", alternate_pin: "!",
                  home_server: "!", locked: "!", location: "!",
                  default_bc: "!", additional_info: "!", home_folder: "!"}
      attribs = defaults.merge( attribs )
      attribs = check_atrribs(attribs)
      "modify ur #{attribs[:user_id]} \"#{attribs[:user_name]}\"" +
      " #{attribs[:min_bal]} #{attribs[:email]} #{attribs[:dept_name]}" +
      " #{attribs[:primary_pin]} #{attribs[:secondary_pin]}" +
      " #{attribs[:quota]} #{attribs[:alternate_pin]}" +
      " #{attribs[:home_server]} #{attribs[:locked]}" +
      " #{attribs[:location]} #{attribs[:default_bc]}" +
      " #{attribs[:additional_info]} #{attribs[:home_folder]}"
    end
  end
end
