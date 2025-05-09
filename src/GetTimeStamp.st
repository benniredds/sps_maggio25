USING Siemens.Simatic.S71500.Clocks;
NAMESPACE ProgramEdge
    FUNCTION GetTimeStamp : INT
        // Function GetTimestamp

        VAR_TEMP
            actDT : LDATE_AND_TIME; // in TIA era Date_and_Time
            TS : LINT; //in TIA era ULINT
            diffLTime : LTime;
            retVal : Int;
            retValRD_LOC_T : Int;
        END_VAR

        VAR_OUTPUT
            Timestamp : UDInt;
        END_VAR

        TS := LINT#0;
        
        //in TIA
        //retValRD_LOC_T := RD_LOC_T(OUT => TIAactDT);

        retValRD_LOC_T := TO_INT(GetLocalDateTime(value => actDT));

        IF  retValRD_LOC_T = 0 OR retValRD_LOC_T = 1 THEN
            
            //in TIA
            //diffLTime := T_DIFF_LTIME(IN1 := TO_LDT(actDT), IN2 := LDT#2020-01-01-00:00:00.0);
            diffLTime := actDT - LDT#2020-01-01-00:00:00.0;
            TS := TO_LINT(diffLTime) / LINT#1000000000;
            retVal := 0;
        ELSE
            retVal := 1;
        END_IF;
        
        Timestamp := TO_UDINT(TS);
        GetTimestamp := retVal;

    END_FUNCTION
END_NAMESPACE


