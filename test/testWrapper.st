USING AxUnit;

USING Libreria.Moduli;
USING Libreria.CustomTypes;

NAMESPACE ValveTests

    {TestFixture}
    CLASS ValveBehaviorTestsFB
        VAR 
            testInstance : WrapperValve;
        END_VAR

        {Test}
        METHOD PUBLIC WrapperBehaviorTest

            VAR_TEMP
                result : BOOL;
            END_VAR

            testInstance(wCmdOpen := TRUE, wCtrlOpen => result);
            Assert.Equal(actual := result, expected := TRUE);

        END_METHOD

    END_CLASS

END_NAMESPACE