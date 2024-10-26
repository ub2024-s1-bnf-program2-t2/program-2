require "io/console"
require "./mod/Graphics"
require "./mod/Generator"
# puts "\e[33m"  # Set terminal color to yellow
puts "\n"  # Add some space before the program starts

# Method to display the BNF grammar
def display_grammar
  grammar = <<-MULTILINE_STATEMENT
  Meta-Language BNF Grammar:

  <program>  => wake <commands> sleep
  <commands> => <command>; | <command>; <commands>
  <command>  => key <button>=<action>
  <button>   => a | b | c | d
  <action>   => DRIVE | BACK | LEFT | RIGHT | SPINL | SPINR
  MULTILINE_STATEMENT
  puts grammar
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
      puts "\e[0m"  # Reset terminal color
      break
    end

    # Attempt to derive the input string using the grammar
    if Graphics.leftmost_derivation(input)
      # If successful, prompt user to continue to draw the parse tree
      puts "\n************************************************************"
      puts "Press any key to draw the parse tree..."
      system("stty raw -echo") # Set terminal to raw mode
      STDIN.raw &.read_char  # Do not assign to variable--discard any input  :: Credit: https://stackoverflow.com/a/39967524/10976415
      system("stty -raw echo") # Reset terminal to normal mode

      # Generate and display the parse tree
      Graphics.draw_parse_tree(input)

      # Prompt user to continue to output the PBASIC code
      puts "\n************************************************************"
      puts "Press any key to output the PBASIC code..."
      STDIN.raw &.read_char  # Do not assign to variable--discard any input  :: Credit: https://stackoverflow.com/a/39967524/10976415

      # Generate PBASIC code based on the valid input string
      Generator.generate_pbasic_code(input)
    end

    # Pause before the next iteration
    puts "\nPress any key to continue..."
    STDIN.raw &.read_char  # Do not assign to variable--discard any input  :: Credit: https://stackoverflow.com/a/39967524/10976415
  end
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
