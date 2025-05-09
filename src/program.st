USING System.Conversion;
USING ProgramEdge;

PROGRAM ProgramCycling
    
    VAR_EXTERNAL CONSTANT
        EnergyConsumptionStarted : REAL;
        EnergyConsumptionHold : REAL;
        EnergyConsumptionMaintenance : REAL;
        EnergyConsumptionStopped : REAL;
        MaxReal : REAL;
        MaxDInt : DINT;
    END_VAR

    VAR_EXTERNAL
        GoodPieces : DINT;
        BadPieces : DINT;
        MachSpeed : REAL;
        MachSpeedSeconds : REAL;
        RejectRatio : REAL;
        MachineStatus : INT;
        TotalPieces : DINT;
        SetpointSpeedSeconds : REAL;
        SetpointSpeed : REAL;
        TimeT : REAL;
        TimeStarted : REAL;
        TimeStopped : REAL;
        LastTimeStopped : REAL;
        LastTimeStarted : REAL;
        LastTimeMaintenance : REAL;
        ProductionActive : BOOL;
        TotalActiveEnergy : LREAL;
        OilLevel : REAL;
        ResetOilLevel : BOOL;
        BatchNum : UDINT;
        BatchPieces : DINT;
        BatchProductName : STRING;
        ProductNames : ARRAY [0..3] OF STRING;
        BatchBadPieces : DINT;
        BatchGoodPieces : DINT;
        BatchTotalPieces : DINT;
    END_VAR
    
    VAR_TEMP
        MachSpeedInACycle : REAL;
        RandomErr : BOOL;
        RandomStatus : WORD;
        RandomSubStatus : WORD;
        InternalVal : REAL;
        RandomVal : REAL;
        RandomTime : REAL;
        RandomSign : INT;
        RandomProductIndex : INT;
        retVal : INT;        
    END_VAR

// get random value from 0.0 to 1.0
RandomVal := LGF_Random_Real(error => RandomErr, status => RandomStatus, subfunctionStatus => RandomSubStatus);
// get random sign based on randomval
IF RandomVal >= 0.6 THEN
    RandomSign := -1;
ELSE
    RandomSign := 1;
END_IF;
// if total batch pieces are reach close the batch
// and start new batch
IF BatchTotalPieces >= BatchPieces
    OR BatchNum = UDINT#0 THEN
    // reset pieces
    BatchBadPieces := 0;
    BatchGoodPieces := 0;
    BatchTotalPieces := 0;
    // set batch num as actual epoch 
    retVal := GetTimestamp(BatchNum);
    // get random value from 0.0 to 1.0
    RandomVal := LGF_Random_Real(error => RandomErr, status => RandomStatus, subfunctionStatus => RandomSubStatus);
    // get a random number of pieces for new batch
    BatchPieces := 10000 + TO_INT(3000 * RandomVal * RandomSign);
    // based on random val get a product index
    // and set to batch product name
    InternalVal:= (TO_INT (RandomVal * 100) / 4);
    RandomProductIndex := TO_INT(RandomVal * 100)- (4 * TO_INT(InternalVal));
    BatchProductName := ProductNames[RandomProductIndex];
    // put machine in stopped status
    MachineStatus := 0;
END_IF;

// 
// increment production time
TimeT := TimeT + REAL#0.5;
IF MachineStatus = 1 THEN
    TimeStarted := TimeStarted + REAL#0.5;
ELSE
    TimeStopped := TimeStopped + REAL#0.5;
END_IF;
// reset time when max reached
IF TimeT >= MaxReal THEN
    TimeT := REAL#0.0;
    TimeStarted := REAL#0.0;
    TimeStopped := REAL#0.0;
END_IF;

// 
// get random value from 0.0 to 1.0
RandomVal := LGF_Random_Real(error => RandomErr, status => RandomStatus, subfunctionStatus => RandomSubStatus);
// get random sign based on randomval
IF RandomVal >= 0.6 THEN
    RandomSign := -1;
ELSE
    RandomSign := 1;
END_IF;

// get a random time 2000 +- 300sec
RandomTime := 2000 + (RandomVal * 300 *RandomSign);
// if the time since machine is started is enough
// try to change machine mode to hold or stopped
IF TimeT - LastTimeStarted > RandomTime THEN
    IF RandomVal >= 0.64 AND RandomVal < 0.74 THEN
        IF MachineStatus = 1 THEN
            // started -> hold
            MachineStatus := 2;
            LastTimeStarted := TimeT;
        END_IF;
    ELSIF RandomVal >= 0.3 AND RandomVal < 0.4 THEN
        IF MachineStatus = 1 THEN
            // started -> stopped
            MachineStatus := 0;
            LastTimeStarted := TimeT;
        END_IF;
    END_IF;
END_IF;

// get a random time 5000 +- 1000sec
RandomTime := 5000 + (RandomVal * 1000 * RandomSign);
// if the time since machine is started is enough,
// try to change machine mode to maintenance
IF TimeT - LastTimeMaintenance > RandomTime THEN
    IF RandomVal >= 0.61 AND RandomVal < 0.84 THEN
        IF MachineStatus = 1 THEN
            // started -> maintenance
            MachineStatus := 3;
            LastTimeMaintenance := TimeT;
        END_IF;
    END_IF;
END_IF;

// get a random time 1000 +- 200sec
RandomTime := 1000 + (RandomVal * 200 * RandomSign);
// if the time since machine is stopped is enough, try to change machine mode
IF TimeT - LastTimeStopped > RandomTime THEN
    IF RandomVal >= 0.25 AND RandomVal < 0.32 THEN
        IF MachineStatus = 2 THEN
            // hold -> started
            MachineStatus := 1;
            LastTimeStopped := TimeT;
        END_IF;
    ELSIF RandomVal >= 0.45 AND RandomVal < 0.52 THEN
        IF MachineStatus = 3 THEN
            // maintenance -> started
            MachineStatus := 1;
            LastTimeStopped := TimeT;
        END_IF;
    ELSIF RandomVal >= 0.71 AND RandomVal < 0.81 THEN
        IF MachineStatus = 0 THEN
            // stopped -> started
            MachineStatus := 1;
            LastTimeStopped := TimeT;
        END_IF;
    END_IF;
END_IF;

// 
// change setpoint speed
IF SetpointSpeed <= 360.0 AND RandomVal >= 0.1 AND RandomVal < 0.15 THEN
    // increase or decrease setpoint
    SetpointSpeed := (SetpointSpeed + REAL#10.0)*RandomSign;
ELSIF SetpointSpeed > 360.0 THEN
    // reset setpoint
    SetpointSpeed := REAL#359.0;
ELSIF SetpointSpeed < 120.0 THEN
    // min limit of machine speed
    SetpointSpeed := REAL#120.0;
END_IF;

// 
// based on machine status
IF MachineStatus = 1 THEN
    // if machine is started
    IF MachSpeed < 120 THEN
        // min limit of machine speed
        MachSpeed := 120;
    END_IF;
    // check production speed
    IF MachSpeed <= SetpointSpeed THEN
        // min limit of machine speed
        MachSpeed := MachSpeed +
        (SetpointSpeed - MachSpeed) * REAL#0.75;
    ELSIF MachSpeed > SetpointSpeed THEN
        // max limit of machine speed
        MachSpeed := SetpointSpeed;
    END_IF;
    // change reject ratio
    IF RejectRatio <= 0.25 THEN
        // increase
        RejectRatio := RejectRatio + REAL#0.05;
    ELSIF RejectRatio > 0.25 THEN
        // reset to min
        RejectRatio := REAL#0.0;
    END_IF;
    // get production ratio in a cycle from pcs/min (every 500 ms)
    MachSpeedInACycle := MachSpeed / REAL#120.0;
    // update speeds in sec
    SetpointSpeedSeconds := SetpointSpeed / REAL#60.0;
    MachSpeedSeconds := MachSpeed / REAL#60.0;
    // status boolean for started status
    ProductionActive := TRUE;
    
    // get random value from 0.0 to 1.0
    RandomVal := LGF_Random_Real(error => RandomErr, status => RandomStatus, subfunctionStatus => RandomSubStatus);
    IF RandomVal < RejectRatio THEN
        // if random < probability of bad production make bad pieces
        BadPieces := BadPieces + TO_DINT(Ceil(MachSpeedInACycle));
        BatchBadPieces := BatchBadPieces + TO_DINT(Ceil(MachSpeedInACycle));
    ELSE
        // else make good pieces
        GoodPieces := GoodPieces + TO_DINT(Ceil(MachSpeedInACycle));
        BatchGoodPieces := BatchGoodPieces + TO_DINT(Ceil(MachSpeedInACycle));
    END_IF;
    // update total
    TotalPieces := GoodPieces + BadPieces;
    BatchTotalPieces := BatchGoodPieces + BatchBadPieces;
    
    // reset pieces when reach max
    IF TotalPieces > MaxDInt THEN
        BatchBadPieces := 0;
        BatchGoodPieces := 0;
       END_IF;
       
ELSIF MachineStatus = 3 THEN
    // update machspeedsec
    SetpointSpeedSeconds := REAL#0.0;
    SetpointSpeed := REAL#0.0;
    // reset speed
    MachSpeed := REAL#0.0;
    MachSpeedSeconds := REAL#0.0;
    // status boolean for started status
    ProductionActive := FALSE;
ELSE
    // reset speed
    MachSpeed := REAL#0.0;
    MachSpeedSeconds := REAL#0.0;
    // status boolean for started status
    ProductionActive := FALSE;
END_IF;

// 
// Energy Consumption based on status
IF MachineStatus = 0 THEN
    TotalActiveEnergy := TotalActiveEnergy + EnergyConsumptionStopped;
ELSIF MachineStatus = 1 THEN
    TotalActiveEnergy := TotalActiveEnergy + EnergyConsumptionStarted;
ELSIF MachineStatus = 2 THEN
    TotalActiveEnergy := TotalActiveEnergy + EnergyConsumptionHold;
ELSIF MachineStatus = 3 THEN
    TotalActiveEnergy := TotalActiveEnergy + EnergyConsumptionMaintenance;
END_IF;
// reset energy on max
IF TotalActiveEnergy >= MaxReal THEN
    TotalActiveEnergy := 0;
END_IF;

// 
// get random value from 0.0 to 1.0
RandomVal := LGF_Random_Real(error => RandomErr, status => RandomStatus, subfunctionStatus => RandomSubStatus);
// OIL Level consumption in production
IF MachineStatus = 1 THEN
    IF RandomVal >= 0.9 AND RandomVal <= 1.0 THEN
        OilLevel := OilLevel - REAL#0.00001;
    ELSIF RandomVal >= 0.4 AND RandomVal < 0.7 THEN
        OilLevel := OilLevel - REAL#0.000006;
    ELSIF RandomVal >= 0.1 AND RandomVal < 0.4 THEN
        OilLevel := OilLevel - REAL#0.000002;
    END_IF;
END_IF;
// OIL Level Reset trigger
IF ResetOilLevel = TRUE THEN
    OilLevel := REAL#100.0;
    ResetOilLevel := FALSE;
END_IF;

END_PROGRAM