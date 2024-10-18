# Method to display the BNF grammar
def display_grammar
  puts <<-GRAMMAR
Meta-Language BNF Grammar:

<program>  ::= "wake" <commands> "sleep"

<commands> ::= <command> <commands> 
             | <command>

<command>  ::= "key" <key> "=" <action> ";"

<key>      ::= "a" | "b" | "c" | "d"

<action>   ::= "DRIVE" | "BACK" | "LEFT" | "RIGHT" | "SPINL" | "SPINR"
         
GRAMMAR
end

# Main method to run the program
def main
  loop do
    # Display the BNF grammar
    display_grammar

    # Prompt user for input string
    puts "\n************************************************************"
    print "Enter an input string (or type 'END' to quit): "
    input = gets

    # Check if input is nil and exit if no input is provided
    if input.nil?
      puts "\n*************************************"
      puts "No input provided."
      puts "************************************************************"
      next
    end

    input = input.strip

    # Exit if the input is 'END'
    if input == "END"
      puts "\n************************************************************"
      puts "Program terminated." 
      break
    end

    # Attempt to derive the input string using the grammar
    if leftmost_derivation(input)
      # If successful, prompt user to continue to draw the parse tree
      puts "\n************************************************************"
      puts "Press any key to draw the parse tree..."
      gets # Wait for user to press a key

      # Generate and display the parse tree
      draw_parse_tree(input)

      # Prompt user to continue to output the PBASIC code
      puts "\n************************************************************"
      puts "Press any key to output the PBASIC code..."
      gets # Wait for user to press a key again

      # Generate PBASIC code based on the valid input string
      generate_pbasic_code(input)
    end

    # Pause before the next iteration
    puts "\nPress any key to continue..."
    gets
  end
end





# Helper function to validate each individual command
def validate_command(command : String) : Bool
  # Check if the command matches the pattern "key <key> = <action>;"
  # This allows optional spaces around the equal sign
  if command.match(/^key\s+([abcd])\s*=\s*(DRIVE|BACK|LEFT|RIGHT|SPINL|SPINR)\s*/)
  
    true
  else
    # Specific error messages based on what went wrong
    if command !~ /^key\s+[abcd]\s*=\s*(DRIVE|BACK|LEFT|RIGHT|SPINL|SPINR)\s*/
      puts "\n************************************************************"
      puts "Error: Invalid command: '#{command}'"
      puts "       Expected format: 'key <a,b,c,d> = DRIVE|BACK|LEFT|RIGHT|SPINL|SPINR>;'"
    end
  
    # Additional checks for missing action
    if command =~ /^key\s+([abcd])\s*=\s*$/
      puts "\n************************************************************"
      puts "Error: Missing action after '=' in command '#{command}'."
    end
  
    false
  end
end
  
# Subprogram to perform leftmost derivation
def leftmost_derivation(input : String) : Bool
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
      if validate_command(command)
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
def draw_parse_tree(input : String)
  puts "Parse Tree:"
  puts "  <program>"
  puts "    |"
  puts "    wake <commands> sleep"
  puts "         |"

  # Remove "wake" and "sleep" and extract commands
  commands = input.gsub(/wake|sleep/, "").strip.split(/;/).map { |cmd| cmd.strip }.reject { |c| c.empty? }

  # Loop through each command and progressively draw the parse tree
  commands.each_with_index do |command, index|
    # Split the command into key and action parts
    key_part = command.split("=").first.strip
    action_part = command.split("=").last.strip.chomp

    # Parse tree branch for each command
    if index == 0
      puts "         <command>"
    else
      puts "         <command> ->"
    end

    puts "           |"
    puts "           key <key> = <action>"

    # Print the actual key and action
    puts "           |"
    puts "           key #{key_part.split(" ").last} = #{action_part}"
  end
end


# Subprogram to generate PBASIC code
def generate_pbasic_code(input : String)
  header = " '{$STAMP BS2p}\n '{$PBASIC 2.5}\n KEY VAR Byte\n Main:\n DO\n"
  footer1 = "Timeout:\n GOSUB Motor_OFF\n GOTO Main\n"
  footer2 = "Motor_OFF: LOW 13 : LOW 12 : LOW 14 : RETURN\n"

  body = ""

  input.scan(/key\s+([abcd])\s*=\s*(\w+)/) do |match|
    key = match[1]  # First capture group (key)
    movement = match[2]  # Second capture group (movement)
    routine = MOVEMENTS[movement]
    body += "IF KEY = \"#{key}\" THEN GOSUB #{routine}\n"
  end

  # Combine all parts into the final PBASIC program
  pbasic_program = header + body + footer1 + footer2

  # Display the generated code
  puts "Generated PBASIC Code:\n#{pbasic_program}"

  # Save the generated code to a file
  File.open("IZEBOT.BSP", "w") do |file|
    file.puts(pbasic_program)
  end

  puts "PBASIC program saved to IZEBOT.BSP"
end

# Constant for the movements and their PBASIC equivalents
MOVEMENTS = {
  "DRIVE" => "Forward",
  "BACK" => "Backward",
  "LEFT" => "TurnLeft",
  "RIGHT" => "TurnRight",
  "SPINL" => "SpinLeft",
  "SPINR" => "SpinRight"
}

# Run the main program
main
