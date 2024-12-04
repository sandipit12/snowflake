CALL deploy_db_schemachange.bat %1 Admin && (
  echo Admin was successful
) || (
  echo Admin failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 AccountScore && (
  echo AccountScore was successful
) || (
  echo AccountScore failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Collections && (
  echo Collections was successful
) || (
  echo Collections failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Decision_Engine && (
  echo Decision_Engine was successful
) || (
  echo Decision_Engine failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Decision_Engine_PreProcessor && (
  echo Decision_Engine_PreProcessor was successful
) || (
  echo Decision_Engine_PreProcessor failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 File_Drop && (
  echo File_Drop was successful
) || (
  echo File_Drop failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Quote && (
  echo Quote was successful
) || (
  echo Quote failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 ConsumerAuto_Quote && (
  echo ConsumerAuto_Quote was successful
) || (
  echo ConsumerAuto_Quote failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 ConsumerAuto_VehicleService && (
  echo ConsumerAuto_VehicleService was successful
) || (
  echo ConsumerAuto_VehicleService failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 ConsumerAuto_ContractAcceptance && (
  echo ConsumerAuto_ContractAcceptance was successful
) || (
  echo ConsumerAuto_ContractAcceptance failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 ConsumerAuto_VehicleRegistration && (
  echo ConsumerAuto_VehicleRegistration was successful
) || (
  echo ConsumerAuto_VehicleRegistration failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Venus_Live && (
  echo Venus_Live was successful
) || (
  echo Venus_Live failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 DWH_Legacy && (
  echo DWH_Legacy was successful
) || (
  echo DWH_Legacy failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Bureau_CallCredit && (
  echo Bureau_CallCredit was successful
) || (
  echo Bureau_CallCredit failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Bureau_Glass && (
  echo Bureau_Glass was successful
) || (
  echo Bureau_Glass failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Sandbox && (
  echo Sandbox was successful
) || (
  echo Sandbox failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 ConsumerAuto_Invoice && (
  echo ConsumerAuto_Invoice was successful
) || (
  echo ConsumerAuto_Invoice failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 ConsumerAuto_ComplianceChecks && (
  echo ConsumerAuto_ComplianceChecks was successful
) || (
  echo ConsumerAuto_ComplianceChecks failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Bureau_Equifax && (
  echo Bureau_Equifax was successful
) || (
  echo Bureau_Equifax failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 LoanCollections && (
  echo LoanCollections was successful
) || (
  echo LoanCollections failed
  goto ERROR
)

CALL deploy_db_schemachange.bat %1 Pricing && (
  echo Pricing was successful
) || (
  echo Pricing failed
  goto ERROR
)

REM DWH MUST BE THE LAST database to deploy
CALL deploy_db_schemachange.bat %1 DWH && (
  echo DWH was successful
) || (
  echo DWH failed
  goto ERROR
)

:ERROR



