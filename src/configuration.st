USING Siemens.Simatic.S71500.Tasks;

//{OpcUa.NodeGenerator.IdType = SymbolName}
CONFIGURATION MyConfiguration
    TASK Main (PRIORITY := 1);
    TASK MyInterruptTask : CyclicInterrupt := (
        CycleTime := T#500ms,
        EventPriority := USINT#13
    );
    
    PROGRAM P1 WITH Main : MainProgram;
    PROGRAM P2 WITH MyInterruptTask : ProgramCycling;
    
    {S7.extern = ReadWrite}
//    {OpcUa.AccessLevel = ReadWrite} 
    VAR_GLOBAL
        GoodPieces : DINT;
        BadPieces : DINT;
        MachSpeed : REAL;
        MachSpeedSeconds : REAL;
        RejectRatio : REAL;
        MachineStatus : INT := 1;
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
        OilLevel : REAL := REAL#100.0;
        ResetOilLevel : BOOL;
        BatchNum : UDINT;
        BatchPieces : DINT := 7000;
        BatchProductName : String := 'Product_C';
        ProductNames : Array[0..3] of String := ['Product_A', 'Product_B', 'Product_C', 'Product_D'];
        BatchBadPieces : DINT;
        BatchGoodPieces : DINT;
        BatchTotalPieces : DINT;
    END_VAR
    
    VAR_GLOBAL CONSTANT
        EnergyConsumptionStarted : REAL := REAL#0.0417;
        EnergyConsumptionHold : REAL := REAL#0.0152;
        EnergyConsumptionMaintenance : REAL := REAL#0.0121;
        EnergyConsumptionStopped : REAL := REAL#0.0243;
        MaxReal : REAL := REAL#1.234567e+20;
        MaxDInt : DINT := DINT#2147483647;
    END_VAR

    VAR_GLOBAL CONSTANT
        ZERO : REAL := REAL#0.0;
        MAX_UDINT : UDINT := UDINT#4294967295; 
        SUB_STATUS_NO_ERROR : WORD := WORD#16#0000;
        STATUS_FINISHED_NO_ERROR : WORD := WORD#16#0000;
        ERR_RD_SYS_T : WORD := WORD#16#8600;
    END_VAR

END_CONFIGURATION
