NAMESPACE Libreria.Moduli
    
    FUNCTION BasicValve
        VAR_INPUT
            cmdOpen : BOOL;
        END_VAR
        
        VAR_OUTPUT
            ctrlOpen : BOOL;
        END_VAR
        
        ctrlOpen := cmdOpen;        

    END_FUNCTION

    FUNCTION_BLOCK AdvancedValve
        VAR_INPUT
            cmdOpen : BOOL;
        END_VAR
        
        VAR_OUTPUT
            ctrlOpen : BOOL;
        END_VAR

        VAR
            isOpened : BOOL;
            isClosed : BOOL;
        END_VAR

        IF cmdOpen THEN
            ctrlOpen := TRUE;
            isOpened := TRUE;
            isClosed := FALSE;
        ELSE
            ctrlOpen := FALSE;
            isOpened := FALSE;
            isClosed := TRUE;
        END_IF;
    END_FUNCTION_BLOCK

END_NAMESPACE