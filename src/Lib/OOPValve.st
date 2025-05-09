USING Libreria.CustomTypes;
NAMESPACE Libreria.Moduli

    CLASS ClassValveBase
        VAR PUBLIC
            ctrlOpen : BOOL;
        END_VAR

        VAR
            isOpened : BOOL;
            isClosed : BOOL;
        END_VAR

        METHOD PUBLIC Open
            ctrlOpen := TRUE;
            isOpened := TRUE;
            isClosed := FALSE;
        END_METHOD
        
        METHOD PUBLIC Close
            ctrlOpen := FALSE;
            isOpened := FALSE;
            isClosed := TRUE;
        END_METHOD
    END_CLASS


    CLASS ClassValve
        VAR PUBLIC
            ctrlOpen : BOOL;
        END_VAR

        VAR
            actualState : ValveState;
        END_VAR

        METHOD PUBLIC Open
            ctrlOpen := TRUE;
            actualState := valveState#Opened;
        END_METHOD
        
        METHOD PUBLIC Close
            ctrlOpen := FALSE;
            actualState := valveState#Closed;
        END_METHOD

        METHOD PUBLIC GetState : ValveState;
            GetState := actualState;
        END_METHOD       
    END_CLASS


    CLASS ClassValveBi EXTENDS ClassValve
        VAR PUBLIC
            //ctrlOpen : BOOL;      già presente in ClassValve!
            ctrlClose : BOOL;
        END_VAR

        METHOD PUBLIC OVERRIDE Open
            ctrlOpen := TRUE;
            ctrlClose := FALSE;
            actualState := valveState#Opened;
            END_METHOD

        METHOD PUBLIC OVERRIDE Close
            ctrlOpen := FALSE;
            ctrlClose := TRUE;
            actualState := valveState#Closed;
        END_METHOD

        // METHOD PUBLIC GetState          già presente in ClassValve!
    END_CLASS

END_NAMESPACE