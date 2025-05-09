USING Libreria.Moduli;

NAMESPACE ProgramModuli

    CLASS Tank IMPLEMENTS ITank
     
        VAR PUBLIC
            inletValve : ClassValve;
            outletValve : ClassValve;
        END_VAR

        METHOD PUBLIC OpenInletValve
            inletValve.Open(); 
        END_METHOD

        METHOD PUBLIC OpenOutletValve
            outletValve.Open(); 
        END_METHOD
        
        METHOD PUBLIC CloseInletValve
            inletValve.Close(); 
        END_METHOD

        METHOD PUBLIC CloseOutletValve
            outletValve.Close(); 
        END_METHOD

        METHOD PUBLIC Fill
            THIS.OpenInletValve(); 
            THIS.CloseOutletValve();
        END_METHOD

        METHOD PUBLIC Close
            THIS.CloseInletValve();
            THIS.CloseOutletValve();
        END_METHOD

        METHOD PUBLIC Flush
            THIS.OpenInletValve();
            THIS.OpenOutletValve();
        END_METHOD

    END_CLASS
    
END_NAMESPACE

