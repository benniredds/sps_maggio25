USING Libreria.CustomTypes;
NAMESPACE Libreria.Moduli

    FUNCTION_BLOCK WrapperValve
            
        VAR_INPUT
            wCmdOpen : BOOL;
        END_VAR

        VAR
            mainValve : ClassValve;
            actualState : ValveState;
        END_VAR

        VAR_OUTPUT
            wCtrlOpen : BOOL;
        END_VAR

        IF wCmdOpen THEN
            mainValve.Open();
        ELSE
            mainValve.Close();
        END_IF;
        
        wCtrlOpen := mainValve.ctrlOpen;
        actualState := mainValve.GetState();
        
    END_FUNCTION_BLOCK

END_NAMESPACE

