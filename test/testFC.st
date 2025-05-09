USING AxUnit;

USING Libreria.Moduli;
USING Libreria.CustomTypes;

NAMESPACE ValveTests

    {Test}
    FUNCTION BasicValveTest

        VAR_TEMP
            testResult : BOOL;
        END_VAR

        BasicValve(cmdOpen := TRUE, ctrlOpen => testResult);
        Assert.Equal(actual := testResult, expected :=TRUE);

    END_FUNCTION

END_NAMESPACE
