require "./Generator"
module Graphics
  # Subprogram to perform leftmost derivation
  def self.leftmost_derivation(input : String) : Bool
    # Check if the string starts with "wake" and ends with "sleep"
    if input =~ /^wake\s+.*\s+sleep$/
      # Display the derivation steps
      puts "\n************************************************************"
      puts "                  Leftmost Derivation:"

      # Step 1: Initial form
      sentential_form = "wake <commands> sleep"
      puts "\n<program>  ->  #{sentential_form}"
      loop = 1

      # Remove "wake" and "sleep" from the input but keep semicolons intact
      commands = input.gsub(/wake|sleep/, "").strip.split(/;/).map { |cmd| cmd.strip }.reject { |c| c.empty? }

      # Step 2: Progressively replace <commands> with <command><commands> for each command
      commands.each_with_index do |_, index|
        if index == 0
          # First step: Replace the first <commands> with <command><commands>
          sentential_form = sentential_form.gsub("<commands>", "<command> <commands>")
        else
          # For subsequent steps, replace the remaining <commands> with <command><commands> progressively
          sentential_form = sentential_form.gsub("<commands>", "<command> <commands>")
        end

        # Once we reach the last command, replace <commands> with just <command>
        if index == commands.size - 1
          sentential_form = sentential_form.gsub(" <commands>", "")
        end

        puts "%02d         ->  #{sentential_form}" % (loop += 1)
      end

      # Process commands, validate, and progressively derive
      commands.each_with_index do |command, index|
        if Generator.validate_command(command)
          key_part = command.split("=").first.strip
          action_part = command.split("=").last.strip.chomp

          # Replace the placeholders in sequence for each command
          sentential_form = sentential_form.sub("<command>", "key <key> = <action>;")
          puts "%02d         ->  #{sentential_form}" % (loop += 1)

          # Replace the <key> placeholder with the actual value
          sentential_form = sentential_form.sub("<key>", key_part.split(" ").last)
          puts "%02d         ->  #{sentential_form}" % (loop += 1)

          # Replace the <action> placeholder with the actual value
          sentential_form = sentential_form.sub("<action>", action_part)
          puts "%02d         ->  #{sentential_form}" % (loop += 1)
        else
          return false
        end
      end

      return true
    else
      # Handle invalid format (if "wake" or "sleep" is missing or misplaced)
      puts "\n************************************************************"
      puts "Error: Input must start with 'wake' and end with 'sleep'"
      return false
    end
  end

  # Subprogram to draw the parse tree
  def self.draw_parse_tree(input : String)
    # Remove "wake" and "sleep", extract and count commands
    commands = input.gsub(/wake|sleep/, "").strip.split(/;/).map { |cmd| cmd.strip }.reject { |c| c.empty? }
    num_commands = commands.size

    puts "                  Parse Tree"

    # Switch statement based on number of commands
    case num_commands
    when 1
      key_part = commands[0].split("=").first.strip
      action_part = commands[0].split("=").last.strip.chomp

      puts "\n                   <program>"
      puts "                       |"
      puts "             wake <commands> sleep"
      puts "                       |"
      puts "                   <command>"
      puts "                       |"
      puts "              key <key>=<action>"
      puts "                   /         \\"
      puts "                  #{key_part.split(" ").last}         #{action_part}"
    when 2
      key_part = commands[0].split("=").first.strip
      action_part = commands[0].split("=").last.strip.chomp

      key_part2 = commands[1].split("=").first.strip
      action_part2 = commands[1].split("=").last.strip.chomp

      puts "\n                   <program>"
      puts "                       |"
      puts "             wake <commands> sleep"
      puts "                       |"
      puts "              <command> <commands>"
      puts "                 /            \\"
      puts "      key <key>=<action>    <command>"
      puts "           /         \\           \\"
      puts "          #{key_part.split(" ").last}         #{action_part}   key <key>=<action>"
      puts "                                 /         \\"
      puts "                                #{key_part2.split(" ").last}          #{action_part2}"
    when 3
      key_part = commands[0].split("=").first.strip
      action_part = commands[0].split("=").last.strip.chomp

      key_part2 = commands[1].split("=").first.strip
      action_part2 = commands[1].split("=").last.strip.chomp

      key_part3 = commands[2].split("=").first.strip
      action_part3 = commands[2].split("=").last.strip.chomp

      puts "\n                   <program>"
      puts "                       |"
      puts "              wake <commands> sleep"
      puts "                       |"
      puts "            <command>    <commands>"
      puts "               /               \\"
      puts "    key <key>=<action>      <command>   <commands>"
      puts "         /         \\             \\             \\"
      puts "        #{key_part.split(" ").last}        #{action_part}   key <key>=<action>  <command>"
      puts "                               /       \\          \\"
      puts "                              #{key_part2.split(" ").last}       #{action_part2}   key <key>=<action>"
      puts "                                                   /       \\"
      puts "                                                  #{key_part3.split(" ").last}        #{action_part3}"
    when 4
      key_part = commands[0].split("=").first.strip
      action_part = commands[0].split("=").last.strip.chomp

      key_part2 = commands[1].split("=").first.strip
      action_part2 = commands[1].split("=").last.strip.chomp

      key_part3 = commands[2].split("=").first.strip
      action_part3 = commands[2].split("=").last.strip.chomp

      key_part4 = commands[3].split("=").first.strip
      action_part4 = commands[3].split("=").last.strip.chomp

      puts "\n                   <program>"
      puts "                       |"
      puts "              wake <commands> sleep"
      puts "                       |"
      puts "            <command>    <commands>"
      puts "               /               \\"
      puts "    key <key>=<action>      <command>    <commands>"
      puts "         /         \\             \\             \\"
      puts "        #{key_part.split(" ").last}        #{action_part}   key <key>=<action>  <command>     <commands>"
      puts "                               /       \\          \\               \\"
      puts "                              #{key_part2.split(" ").last}       #{action_part2}   key <key>=<action>  <command>"
      puts "                                                   /       \\          \\"
      puts "                                                  #{key_part3.split(" ").last}        #{action_part3}   key <key>=<action>"
      puts "                                                                        /       \\"
      puts "                                                                       #{key_part4.split(" ").last}        #{action_part4}"
    else
      puts "Error: Unsupported number of commands. Max allowed is 4."
    end
  end
end
