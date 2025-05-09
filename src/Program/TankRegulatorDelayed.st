USING Libreria.Moduli;
USING System.Timer;
USING ProgramModuli;
USING ProgramCustomTypes;

NAMESPACE directloading.ModuliOOP
    FUNCTION_BLOCK TankRegulatorDelayed
        VAR_INPUT
            enable: BOOL;
            tank : REF_TO Tank;
        END_VAR
        VAR
            stateTankMachine : TankState := TankState#Stopped;
            timer : OnDelay;
        END_VAR

        IF NOT enable THEN
            stateTankMachine := TankState#Stopped;
        END_IF;

        CASE stateTankMachine OF

            TankState#Stopped: 
                tank^.Close();
                timer(signal:=false, duration:=LT#0s);
                IF enable THEN
                    stateTankMachine:= TankState#Filling;
                END_IF;

            TankState#Filling:
                timer(signal:=true, duration:=LT#10s);
                tank^.Fill();
                IF timer.output THEN
                    stateTankMachine:= TankState#Emptying;
                    timer(signal:=false, duration:=LT#0s);
                END_IF;
            
            TankState#Emptying:
                timer(signal:=true, duration:=LT#10s);
                tank^.Flush();
                IF timer.output THEN
                    stateTankMachine:= TankState#Filling;
                    timer(signal:=false, duration:=LT#0s);
                END_IF;
        END_CASE;
    END_FUNCTION_BLOCK
END_NAMESPACE

