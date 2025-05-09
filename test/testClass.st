USING AxUnit;
USING Libreria.Moduli;
USING Libreria.CustomTypes;

NAMESPACE ValveTests

    {TestFixture}
    CLASS ValveBehaviorTestsCLASS

        VAR PROTECTED
            testInstance : ClassValve;
        END_VAR

        {Test}
        METHOD PUBLIC OpenBehaviorTest

            VAR_TEMP
                result : valveState;
            END_VAR

            testInstance.Open();    
            result:= testInstance.GetState();       
            Assert.Equal(actual := testInstance.ctrlOpen, expected := TRUE);
            Assert.Equal(actual := result, expected := valveState#Opened);

        END_METHOD

        {Test}
        METHOD PUBLIC CloseBehaviorTest

            VAR_TEMP
                result : valveState;
            END_VAR

            testInstance.Close();
            result:= testInstance.GetState();  
            Assert.Equal(actual := testInstance.ctrlOpen, expected := FALSE);
            Assert.Equal(actual := result, expected := valveState#Closed);
        
        END_METHOD

    END_CLASS

END_NAMESPACE
