module Snippets
    class Movement
        FORWARD = "Forward: HIGH 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN"
        BACKWARD = "Backward: HIGH 12 : LOW 13 : HIGH 14 : LOW 15 : RETURN"
        TURNLEFT = "TurnLeft: HIGH 13 : LOW 12 : LOW 15 : LOW 14 : RETURN"
        TURNRIGHT = "TurnRight: LOW 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN"
        SPINLEFT = "SpinLeft: HIGH 13 : LOW 12 : HIGH 14 : LOW 15 : RETURN"
        SPINRIGHT = "SpinRight: HIGH 12 : LOW 13 : HIGH 15 : LOW 14 : RETURN"

        MOTOROFF = "Motor_OFF: LOW 13 : LOW 12 : LOW 15 : LOW 14 : RETURN"

        @@forward_queried = false
        @@backward_queried = false
        @@turnleft_queried = false
        @@turnright_queried = false
        @@spinleft_queried = false
        @@spinright_queried = false

        def self.initialize()
            @@forward_queried = false
            @@backward_queried = false
            @@turnleft_queried = false
            @@turnright_queried = false
            @@spinleft_queried = false
            @@spinright_queried = false
        end
        def self.get(routine : String)
            case routine
            when "MOTOROFF"
                return MOTOROFF
            when "Forward"
                if !@@forward_queried
                    @@forward_queried = true
                    return FORWARD
                end
                return false
            when "Backward"
                if !@@backward_queried
                    @@backward_queried = true
                    return BACKWARD
                end
                return false
            when "TurnLeft"
                if !@@turnleft_queried
                    @@turnleft_queried = true
                    return TURNLEFT
                end
                return false
            when "TurnRight"
                if !@@turnright_queried
                    @@turnright_queried = true
                    return TURNRIGHT
                end
                return false
            when "SpinLeft"
                if !@@spinleft_queried
                    @@spinleft_queried = true
                    return SPINLEFT
                end
                return false
            when "SpinRight"
                if !@@spinright_queried
                    @@spinright_queried = true
                    return SPINRIGHT
                end
                return false
            else
                raise "Unknown routine: #{routine}"
            end
        end
    end
end
