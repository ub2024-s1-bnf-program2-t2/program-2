require "./Snippets"
module Generator
  # Helper function to validate each individual command
  def self.validate_command(command : String) : Bool
    # Check if the command matches the pattern "key <button> = <action>;"
    # This allows optional spaces around the equal sign
    if command.match(/^key\s+([abcd])\s*=\s*(DRIVE|BACK|LEFT|RIGHT|SPINL|SPINR)\s*/)
      true
    else
      # Specific error messages based on what went wrong
      if command !~ /^key\s+[abcd]\s*=\s*(DRIVE|BACK|LEFT|RIGHT|SPINL|SPINR)\s*/
        puts "\n************************************************************"
        puts "\e[0;31mError: Invalid command: '#{command}'"
        puts "       Expected format: 'key <a,b,c,d> = DRIVE|BACK|LEFT|RIGHT|SPINL|SPINR;'\e[0;0m"
      end

      # Additional checks for missing action
      if command =~ /^key\s+([abcd])\s*=\s*$/
        puts "\n************************************************************"
        puts "\e[0;31mError: Missing action after '=' in command '#{command}'.\e[0;0m"
      end

      false
    end
  end

  # Subprogram to generate PBASIC code
  def self.generate_pbasic_code(input : String)
    # Note: The spaces in the snippets are !!!IMPORTANT!!! for the indentation in the generated code
    header = "'--- HEADER ---\n'{$STAMP BS2p}\n'{$PBASIC 2.5}\nKEY VAR Byte\nMain:\n   DO\n      SERIN 3,2063,250,Timeout,[KEY]\n"
    footer1 = "'--- FOOTER 1 ---\n   LOOP\nTimeout:\n   GOSUB Motor_OFF\n   GOTO Main\n"
    footer2 = "'--- FOOTER 2 ---\n#{Snippets::Movement.get("MOTOROFF").to_s}\n"

    # Please !!!DO NOT!!! change the indentation in the snippets
    body = "'--- BODY ---\n"
    subroutine = "'--- SUBROUTINES ---\n"

    input.scan(/key\s+([abcd])\s*=\s*(\w+)/) do |match|
      key = match[1]      # First capture group (key)
      movement = match[2] # Second capture group (movement)
      routine = MOVEMENTS[movement]
      # !!!IMPORTANT!!! The indentation in the snippets is important for the generated code
      body += "      IF KEY = \"#{key}\" THEN GOSUB #{routine}\n"
      snippet = Snippets::Movement.get(routine)
      if snippet
        subroutine += snippet.to_s + "\n"
      end
    end

    # Combine all parts into the final PBASIC program
    pbasic_program = header + body + footer1 + subroutine + footer2

    # Display the generated code
    puts "Generated PBASIC Code:\n\n"    
    # puts "\e[47m\e[0;33m#{pbasic_program}\e[0m"
    puts "\e[1;32m\n\n#{pbasic_program}\n\n\e[0;0m"

    # Save the generated code to a file
    File.open("IZEBOT.BSP", "w") do |file|
      file.puts(pbasic_program)
    end

    puts "\nGenerating object code..."
    Process.run \
      command: "make", args: ["compile", "file=IZEBOT"],
      shell: true,
      chdir: Dir.current

    puts "PBASIC program saved to IZEBOT.BSP"
    puts "Object code saved to 'out/IZEBOT.bin'"
  end
end
