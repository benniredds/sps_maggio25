USING System.Timer;
USING ProgramModuli;
USING ProgramCustomTypes;

PROGRAM MainProgram
    VAR_EXTERNAL
        //use lamp to import global variables from Configuration
        enable: BOOL;
        tank : Tank;
        ctrlInletOpen : BOOL;
        ctrlOutletOpen : BOOL;
    END_VAR

    VAR 
        stateTankMachine : TankState := TankState#Stopped;
        timer : OnDelay;
    END_VAR

    VAR CONSTANT
        speedAxisDB  : UINT := UINT#1;
    END_VAR

    // state machine
    IF NOT enable THEN
        stateTankMachine := TankState#Stopped;
    END_IF;

    CASE stateTankMachine OF

        TankState#Stopped: 
            tank.Close();
            timer(signal:=false, duration:=LT#0s);
            IF enable THEN
                stateTankMachine:= TankState#Filling;
            END_IF;

        TankState#Filling:
            timer(signal:=true, duration:=LT#10s);
            tank.Fill();
            IF timer.output THEN
                stateTankMachine:= TankState#Emptying;
                timer(signal:=false, duration:=LT#0s);
            END_IF;
        
        TankState#Emptying:
            timer(signal:=true, duration:=LT#10s);
            tank.Flush();
            IF timer.output THEN
                stateTankMachine:= TankState#Filling;
                timer(signal:=false, duration:=LT#0s);
            END_IF;
    END_CASE;

    // connection to the Tanks --> we need to pass them to FB inputs!
    ctrlInletOpen:=tank.inletValve.ctrlOpen;
    ctrlOutletOpen:=tank.outletValve.ctrlOpen;

END_PROGRAM