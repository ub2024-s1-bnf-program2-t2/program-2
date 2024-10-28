require "./Generator"
module Graphics
  # Subprogram to perform leftmost derivation
  def self.leftmost_derivation(input : String) : Bool
    # Check if the string starts with "wake" and ends with "sleep"
    if input =~ /^wake\s+.*\s+sleep$/
      # Display the derivation steps
      puts "\n************************************************************"
      puts "                  Leftmost Derivation:"
      puts "\e[1;32m"

      # Step 1: Initial form
      sentential_form = "\e[0;32mwake \e[1;37m<commands>\e[1;0m  \e[0;32msleep\e[1;0m "
      puts "\n<program>  ->  #{sentential_form}"
      loop = 1

      # Remove "wake" and "sleep" from the input but keep semicolons intact
      commands = input.gsub(/wake|sleep/, "").strip.split(/;/).map { |cmd| cmd.strip }.reject { |c| c.empty? }

      # Step 2: Progressively replace <commands> with <command><commands> for each command
      commands.each_with_index do |_, index|
        if index == 0
          # First step: Replace the first <commands> with <command><commands>
          sentential_form = sentential_form.gsub("<commands>", "\e[1;37m<command>\e[0;35m; \e[1;37m<commands>\e[1;0m")
        else
          # For subsequent steps, replace the remaining <commands> with <command><commands> progressively
          sentential_form = sentential_form.gsub("<commands>", "\e[1;37m<command>\e[0;35m; \e[1;37m<commands>\e[1;0m")
        end

        # Once we reach the last command, replace <commands> with just <command>
        if index == commands.size - 1
          sentential_form = sentential_form.gsub("<commands>", "")
        end

        puts "%02d         ->  #{sentential_form}" % (loop += 1)
      end

      # Process commands, validate, and progressively derive
      commands.each_with_index do |command, index|
        if Generator.validate_command(command)
          key_part = command.split("=").first.strip
          action_part = command.split("=").last.strip.chomp

          # Replace the placeholders in sequence for each command
          sentential_form = sentential_form.sub("<command>", "\e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m")
          puts "%02d         ->  #{sentential_form}" % (loop += 1)

          # Replace the <button> placeholder with the actual value
          sentential_form = sentential_form.sub("<button>", "\e[0;31m" + key_part.split(" ").last + "\e[1;0m")
          puts "%02d         ->  #{sentential_form}" % (loop += 1)

          # Replace the <action> placeholder with the actual value
          sentential_form = sentential_form.sub("<action>", "\e[0;34m" + action_part + "\e[1;0m")
          puts "%02d         ->  #{sentential_form}" % (loop += 1)
        else
          return false
        end
      end
      puts "\e[0;0m"
      return true
    else
      # Handle invalid format (if "wake" or "sleep" is missing or misplaced)
      puts "\n************************************************************"
      puts "\e[0;31mError: Input must start with 'wake' and end with 'sleep'\e[0;0m"
      return false
    end
  end

  # Subprogram to draw the parse tree
  def self.draw_parse_tree(input : String)
    # Remove "wake" and "sleep", extract and count commands
    commands = input.gsub(/wake|sleep/, "").strip.split(/;/).map { |cmd| cmd.strip }.reject { |c| c.empty? }
    num_commands = commands.size

    puts "                  Parse Tree"
    puts "\e[1;32m"

    # Switch statement based on number of commands
    case num_commands
    when 1
      key_part = commands[0].split("=").first.strip
      action_part = commands[0].split("=").last.strip.chomp

      puts "\n                   \e[1;37m<program>\e[1;0m"
      puts "                       |"
      puts "             \e[0;32mwake \e[1;37m<commands>\e[1;0m \e[0;32msleep\e[1;0m"
      puts "                       |"
      puts "                   \e[1;37m<command>\e[1;0m"
      puts "                       |"
      puts "              \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m"
      puts "                   /         \\"
      puts "                  #{"\e[0;31m" + key_part.split(" ").last}         #{"\e[0;34m" + action_part + "\e[1;0m"}"
    when 2
      key_part = commands[0].split("=").first.strip
      action_part = commands[0].split("=").last.strip.chomp

      key_part2 = commands[1].split("=").first.strip
      action_part2 = commands[1].split("=").last.strip.chomp

      puts "\n                   \e[1;37m<program>\e[1;0m"
      puts "                       |"
      puts "             \e[0;32mwake \e[1;37m<commands>\e[1;0m \e[0;32msleep\e[1;0m"
      puts "                       |"
      puts "              \e[1;37m<command> \e[1;37m<commands>\e[1;0m"
      puts "                 /            \\"
      puts "      \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m    \e[1;37m<command>\e[1;0m"
      puts "           /         \\           \\"
      puts "          #{"\e[0;31m" + key_part.split(" ").last}         #{"\e[0;34m" + action_part + "\e[1;0m"}   \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m"
      puts "                                 /         \\"
      puts "                                #{"\e[0;31m" + key_part2.split(" ").last}          #{"\e[0;34m" + action_part2 + "\e[1;0m"}"
    when 3
      key_part = commands[0].split("=").first.strip
      action_part = commands[0].split("=").last.strip.chomp

      key_part2 = commands[1].split("=").first.strip
      action_part2 = commands[1].split("=").last.strip.chomp

      key_part3 = commands[2].split("=").first.strip
      action_part3 = commands[2].split("=").last.strip.chomp

      puts "\n                   \e[1;37m<program>\e[1;0m"
      puts "                       |"
      puts "              \e[0;32mwake \e[1;37m<commands>\e[1;0m \e[0;32msleep\e[1;0m"
      puts "                       |"
      puts "            \e[1;37m<command>    \e[1;37m<commands>\e[1;0m"
      puts "               /               \\"
      puts "    \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m      \e[1;37m<command>   \e[1;37m<commands>\e[1;0m"
      puts "         /         \\             \\             \\"
      puts "        #{"\e[0;31m" + key_part.split(" ").last}        #{"\e[0;34m" + action_part}   \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m  \e[1;37m<command>"
      puts "                               /       \\          \\"
      puts "                              #{"\e[0;31m" + key_part2.split(" ").last}       #{"\e[0;34m" + action_part2}   \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m"
      puts "                                                   /       \\"
      puts "                                                  #{"\e[0;31m" + key_part3.split(" ").last}        #{"\e[0;34m" + action_part3 + "\e[1;0m"}"
    when 4
      key_part = commands[0].split("=").first.strip
      action_part = commands[0].split("=").last.strip.chomp

      key_part2 = commands[1].split("=").first.strip
      action_part2 = commands[1].split("=").last.strip.chomp

      key_part3 = commands[2].split("=").first.strip
      action_part3 = commands[2].split("=").last.strip.chomp

      key_part4 = commands[3].split("=").first.strip
      action_part4 = commands[3].split("=").last.strip.chomp

      puts "\n                   \e[1;37m<program>\e[1;0m"
      puts "                       |"
      puts "              \e[0;32mwake \e[1;37m<commands>\e[1;0m \e[0;32msleep\e[1;0m"
      puts "                       |"
      puts "            \e[1;37m<command>    \e[1;37m<commands>\e[1;0m"
      puts "               /               \\"
      puts "    \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m      \e[1;37m<command>    \e[1;37m<commands>\e[1;0m"
      puts "         /         \\             \\             \\"
      puts "        #{"\e[0;31m" + key_part.split(" ").last}        #{"\e[0;34m" + action_part}   \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m  \e[1;37m<command>     \e[1;37m<commands>\e[1;0m"
      puts "                               /       \\          \\               \\"
      puts "                              #{"\e[0;31m" + key_part2.split(" ").last}       #{"\e[0;34m" + action_part2}   \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m  \e[1;37m<command>"
      puts "                                                   /       \\          \\"
      puts "                                                  #{"\e[0;31m" + key_part3.split(" ").last}        #{"\e[0;34m" + action_part3}   \e[0;33mkey \e[1;37m<button>\e[1;0m\e[0;35m=\e[1;37m<action>\e[1;0m"
      puts "                                                                        /       \\"
      puts "                                                                       #{"\e[0;31m" + key_part4.split(" ").last}        #{"\e[0;34m" + action_part4 + "\e[1;0m"}"
    else
      puts "\e[0;31mError: Unsupported number of commands. Max allowed is 4.\e[0;0m"
    end
    puts "\e[0;0m"
  end
end
