require "./Snippets"
module Generator
  # Helper function to validate each individual command
  def self.validate_command(command : String) : Bool
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

  # Subprogram to generate PBASIC code
  def self.generate_pbasic_code(input : String)
    header = "'--- HEADER ---\n '{$STAMP BS2p}\n '{$PBASIC 2.5}\n KEY VAR Byte\n Main:\n DO\nSERIN 3,2063,250,Timeout,[KEY]\n"
    footer1 = "'--- FOOTER 1 ---\n LOOP\nTimeout:\n GOSUB Motor_OFF\n GOTO Main\n"
    footer2 = "'--- FOOTER 2 ---\n Motor_OFF: LOW 13 : LOW 12 : LOW 14 : RETURN\n"

    body = "'--- BODY ---\n"
    subroutine = "'--- SUBROUTINES ---\n"

    input.scan(/key\s+([abcd])\s*=\s*(\w+)/) do |match|
      key = match[1]      # First capture group (key)
      movement = match[2] # Second capture group (movement)
      routine = MOVEMENTS[movement]
      body += "IF KEY = \"#{key}\" THEN GOSUB #{routine}\n"
      snippet = Snippets::Movement.get(routine)
      if snippet
        subroutine += snippet.to_s + "\n"
      end
    end

    # Combine all parts into the final PBASIC program
    pbasic_program = header + body + footer1 + subroutine + footer2

    # Display the generated code
    puts "Generated PBASIC Code:\n#{pbasic_program}"

    # Save the generated code to a file
    File.open("IZEBOT.BSP", "w") do |file|
      file.puts(pbasic_program)
    end

    puts "Generating object code..."
    Process.exec \
      command: "make", args: ["compile", "file=IZEBOT"],
      shell: true,
      chdir: Dir.current

    puts "PBASIC program saved to IZEBOT.BSP"
    puts "Object code saved to 'out'"
  end
end
