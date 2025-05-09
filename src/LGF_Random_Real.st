USING Siemens.Simatic.S71500.Clocks;
USING System.DateTime;
NAMESPACE ProgramEdge

    TYPE
        DTL : STRUCT
            YEAR : UINT;
            MONTH : USINT;
            DAY : USINT;
            WEEKDAY : USINT;
            HOUR : USINT;
            MINUTE : USINT;
            SECOND : USINT;
            NANOSECOND : UDINT;
        END_STRUCT;
    END_TYPE

    FUNCTION LGF_Random_Real : REAL
        VAR_EXTERNAL CONSTANT
            ZERO : REAL;
            MAX_UDINT : UDINT;
            SUB_STATUS_NO_ERROR : WORD;
            STATUS_FINISHED_NO_ERROR : WORD;
            ERR_RD_SYS_T : WORD;
        END_VAR

        VAR_OUTPUT
            error : BOOL;
            status : WORD;
            subfunctionStatus : WORD;
        END_VAR

        VAR_TEMP
            //tempTime : DTL;
            tempTime : LDATE_AND_TIME;
            tempTimeNanoSecond : INT;
            tempNanoSecondInDWord : DWORD;
            tempTimeStatus : WORD;
            tempRandomValue : DWORD;
        END_VAR
        ;
    
    // Read system time
    GetSystemDateTime(value => tempTime);
    
    //non abbiamo ritorno
    // Check return variable for error
    /*IF (tempTimeStatus <> SUB_STATUS_NO_ERROR) THEN
        error := true;
        status := ERR_RD_SYS_T;
        subfunctionStatus := tempTimeStatus;
        LGF_Random_Real := ZERO;
        RETURN;
    END_IF;*/


    SplitDateAndTime(
            value := tempTime,
            nanosecond => tempTimeNanoSecond
        );

    // Converting to double word so individual bytes can be addressed
    tempNanoSecondInDWord := TO_DWORD(tempTimeNanoSecond);
    
    // Calculate a random-start-value depending on the time
    tempRandomValue.%B3 := tempNanoSecondInDWord.%B0;
    tempRandomValue.%B2 := tempNanoSecondInDWord.%B1;
    tempRandomValue.%B1 := tempNanoSecondInDWord.%B2;
    tempRandomValue.%B0 := tempNanoSecondInDWord.%B3;
    
    // Norm the calculated random number: 0.0 <= Random_Real <= 1.0
    LGF_Random_Real := TO_REAL(TO_UDINT(tempRandomValue)) / TO_REAL(MAX_UDINT);
    
    error := false;
    status := STATUS_FINISHED_NO_ERROR;
    subfunctionStatus := SUB_STATUS_NO_ERROR;
    
    END_FUNCTION
END_NAMESPACE