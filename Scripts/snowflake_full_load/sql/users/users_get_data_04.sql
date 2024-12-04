SET NOCOUNT ON;

-- Use double quotes instead of single quotes 
SELECT 
    [UserId]
      ,[UserGUID]
      ,CHAR(34) + REPLACE(REPLACE([Username],CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34) 
      ,[CreateDate]
      ,[UpdateDate]
      ,[AccountStatus]
      ,[IdentityStatus]
      ,[IdentityCheckCount]
      ,[LoginAttempts]
      ,[LastLoginDate]
      ,[CurrentLoginDate]
      ,[OriginalIPAddress]
      ,[CurrentIPAddress]
      ,[Title]
      ,CHAR(34) + REPLACE(REPLACE([FirstName],CHAR(34), "\" + CHAR(34)),CHAR(9),"") + CHAR(34)
      ,[OtherNames]
      ,CHAR(34) + REPLACE(REPLACE([LastName],CHAR(34), "\" + CHAR(34)),char(13) + char(10),"") + CHAR(34)
      ,[DateOfBirth]
      ,[RSAccountNumber]
      ,[DDInstructionCompleted]
      ,CHAR(34) + REPLACE(REPLACE([TrackingSource],CHAR(34), "\" + CHAR(34)),CHAR(9),"    ") + CHAR(34)
      ,CHAR(34) + REPLACE(REPLACE([TrackingPromo],CHAR(34), "\" + CHAR(34)),CHAR(9),"    ") + CHAR(34)
      ,CHAR(34) + REPLACE(REPLACE([TrackingCreative],CHAR(34), "\" + CHAR(34)),CHAR(9),"    ") + CHAR(34)
      ,CHAR(34) + REPLACE(REPLACE([TrackingUrl],CHAR(34), "\" + CHAR(34)),CHAR(9),"    ") + CHAR(34)
      ,CHAR(34) + REPLACE(REPLACE([TrackingKeywords],CHAR(34), "\" + CHAR(34)),CHAR(9),"    ") + CHAR(34)
      ,[RunCreditChecks]
      ,[LatestIdentityScore]
      ,[BorrowerLevel]
      ,[LenderLevel]
      ,[Affiliate]
      ,[AffiliateCode]
      ,[AffiliateId]
      ,[RegisteredDate]
      ,[LenderCommissionRate]
      ,[FraudStatus]
      ,[AcceptedDate]
      ,[SessionPersistence]
      ,[PreferredContactType]
      ,[AssignedTo]
      ,[IsAffiliate]
      ,[RequestSource]
      ,[ContactSetting]
      ,[BorrowerNoReminders]
      ,[TermsAccepted]
      ,[AdditionalCreditAllowed]
      ,[FailedContact]
      ,[RSCustomerStatus]
      ,[RSCreditStatus]
      ,CHAR(34) + REPLACE(REPLACE([ManualPaymentRef],CHAR(34), "\" + CHAR(34)),CHAR(9),"    ") + CHAR(34)
      ,[CurrentIdentityStatus]
      ,[PIN]
      ,[PINSecurity]
      ,CHAR(34) + REPLACE(REPLACE([CIFASref],CHAR(34), "\" + CHAR(34)),CHAR(9),"    ") + CHAR(34)
      ,[CIFASStatus]
      ,[PaymentWithdrawalStatus]
      ,[OFAStatus]
      ,[WrongPINEntry]
      ,[ThirdPartyReference]
      ,[WithdrawalPendingStatus]
      ,[FraudMatchStatus]
      ,[IFA_ID]
      ,[FCA_Accepted]
      ,[RA_Accepted]
      ,[CIFASListedOn]
      ,[IFA_NoRI_Reminder]
      ,[IFA_NoIF_Reminder]
      ,[IFA_NoRI_EndDate]
      ,[IFA_NoIF_EndDate]
      ,[ConfirmedFraudDate]
      ,[ReasonDeclinedAsLender]
      ,[AccountType]
      ,[CaseStudyStatus]
      ,[EOPStatus]
      ,[PEPStatus]
      ,[AdditionalCreditAllowedSetDate]
      ,[IPGeoLocation]
      ,[MasterUserID]
      ,[NIN]
      ,[FirstDateOfCreditAtAnyAddress]
      ,[RowVersion]
	    ,AffiliateUserId
      /* metadata colums -- should not incldue in the hash_key */
    ,@@ServerName as Source_System
    ,convert(date, getdate()) as Snapshot_Date
/*--------------------------------------------------------------------
-- derived business key
-------------------------------------------------------------------- */
    ,HASHBYTES("SHA2_256",
      CONCAT_WS("|",
          [UserId]
          ,[UserGUID]
          ,[Username]
          ,[CreateDate]
          ,[UpdateDate]
          ,[AccountStatus]
          ,[IdentityStatus]
          ,[IdentityCheckCount]
          ,[LoginAttempts]
          ,[LastLoginDate]
          ,[CurrentLoginDate]
          ,[OriginalIPAddress]
          ,[CurrentIPAddress]
          ,[Title]
          ,[FirstName]
          ,[OtherNames]
          ,[LastName]
          ,[DateOfBirth]
          ,[RSAccountNumber]
          ,[DDInstructionCompleted]
          ,[TrackingSource]
          ,[TrackingPromo]
          ,[TrackingCreative]
          ,[TrackingUrl]
          ,[TrackingKeywords]
          ,[RunCreditChecks]
          ,[LatestIdentityScore]
          ,[BorrowerLevel]
          ,[LenderLevel]
          ,[Affiliate]
          ,[AffiliateCode]
          ,[AffiliateId]
          ,[RegisteredDate]
          ,[LenderCommissionRate]
          ,[FraudStatus]
          ,[AcceptedDate]
          ,[SessionPersistence]
          ,[PreferredContactType]
          ,[AssignedTo]
          ,[IsAffiliate]
          ,[RequestSource]
          ,[ContactSetting]
          ,[BorrowerNoReminders]
          ,[TermsAccepted]
          ,[AdditionalCreditAllowed]
          ,[FailedContact]
          ,[RSCustomerStatus]
          ,[RSCreditStatus]
          ,[ManualPaymentRef]
          ,[CurrentIdentityStatus]
          ,[PIN]
          ,[PINSecurity]
          ,[CIFASref]
          ,[CIFASStatus]
          ,[PaymentWithdrawalStatus]
          ,[OFAStatus]
          ,[WrongPINEntry]
          ,[ThirdPartyReference]
          ,[WithdrawalPendingStatus]
          ,[FraudMatchStatus]
          ,[IFA_ID]
          ,[FCA_Accepted]
          ,[RA_Accepted]
          ,[CIFASListedOn]
          ,[IFA_NoRI_Reminder]
          ,[IFA_NoIF_Reminder]
          ,[IFA_NoRI_EndDate]
          ,[IFA_NoIF_EndDate]
          ,[ConfirmedFraudDate]
          ,[ReasonDeclinedAsLender]
          ,[AccountType]
          ,[CaseStudyStatus]
          ,[EOPStatus]
          ,[PEPStatus]
          ,[AdditionalCreditAllowedSetDate]
          ,[IPGeoLocation]
          ,[MasterUserID]
          ,[NIN]
          ,[FirstDateOfCreditAtAnyAddress]
          ,[RowVersion]
          ,AffiliateUserId
		  	/*ENUM VALUES*/
		  ,e1.ENUMITEMKEY
		  ,e2.ENUMITEMKEY
		  ,e3.ENUMITEMKEY
		  ,e4.ENUMITEMKEY
		  ,e5.ENUMITEMKEY
		  ,e6.ENUMITEMKEY
		  ,e7.ENUMITEMKEY
		  ,e8.ENUMITEMKEY
		  ,e9.ENUMITEMKEY
		  ,e10.ENUMITEMKEY
		  ,e11.ENUMITEMKEY
		  ,e12.ENUMITEMKEY
		  ,e13.ENUMITEMKEY
		  ,e14.ENUMITEMKEY
		  ,e15.ENUMITEMKEY
		  ,e16.ENUMITEMKEY
		  ,e17.ENUMITEMKEY
		  ,e18.ENUMITEMKEY
		  ,e19.ENUMITEMKEY
		  ,e20.ENUMITEMKEY
		  ,e21.ENUMITEMKEY
		  ,e22.ENUMITEMKEY
		  ,e23.ENUMITEMKEY
		  ,e24.ENUMITEMKEY
        )
    ) AS hash_key
		  ,e1.ENUMITEMKEY AS Account_Status_Name
		  ,e2.ENUMITEMKEY AS Identity_Status_Name
		  ,e3.ENUMITEMKEY AS Borrower_Level_Name
		  ,e4.ENUMITEMKEY AS Lender_Level_Name
		  ,e5.ENUMITEMKEY AS Fraud_Status_Name
		  ,e6.ENUMITEMKEY AS Preferred_Contact_Type_Name
		  ,e7.ENUMITEMKEY AS Request_Source_Name
		  ,e8.ENUMITEMKEY AS Contact_Setting_Name
		  ,e9.ENUMITEMKEY AS Terms_Accepted_Name
		  ,e10.ENUMITEMKEY AS RS_Customer_Status_Name
		  ,e11.ENUMITEMKEY AS RS_Credit_Status_Name
		  ,e12.ENUMITEMKEY AS Current_Identity_Status_Name
		  ,e13.ENUMITEMKEY AS CIFAS_Status_Name
		  ,e14.ENUMITEMKEY AS Payment_Withdrawal_Status_Name
		  ,e15.ENUMITEMKEY AS OFA_Status_Name
		  ,e16.ENUMITEMKEY AS Withdrawl_Pending_Status_Name
		  ,e17.ENUMITEMKEY AS Fraud_Match_Status_Name
		  ,e18.ENUMITEMKEY AS FCA_Accepted_Name
		  ,e19.ENUMITEMKEY AS RA_Accepted_Name
		  ,e20.ENUMITEMKEY AS Reason_Declined_As_Lender_Name
		  ,e21.ENUMITEMKEY AS Account_Type_Name
		  ,e22.ENUMITEMKEY AS Casestudy_Status_Name
		  ,e23.ENUMITEMKEY AS EOP_Status_Name
		  ,e24.ENUMITEMKEY AS PEP_Status_NAME
  FROM [dbo].[Users] u
    LEFT JOIN dbo.ENUMMAPREADONLY e1 ON u.ACCOUNTSTATUS=e1.ENUMITEMNUMBER AND e1.ENUMTYPEFULLYQUALIFIEDNAME="RS.UserAccountStatus"
    LEFT JOIN dbo.ENUMMAPREADONLY e2 ON u.IDENTITYSTATUS=e2.ENUMITEMNUMBER AND e2.ENUMTYPEFULLYQUALIFIEDNAME="RS.DataProvider.API.IdentityCheckResult"
    LEFT JOIN dbo.ENUMMAPREADONLY e3 ON u.BORROWERLEVEL=e3.ENUMITEMNUMBER AND e3.ENUMTYPEFULLYQUALIFIEDNAME="RS.CustomerLevel"
    LEFT JOIN dbo.ENUMMAPREADONLY e4 ON u.LENDERLEVEL=e4.ENUMITEMNUMBER AND e4.ENUMTYPEFULLYQUALIFIEDNAME="RS.CustomerLevel"
    LEFT JOIN dbo.ENUMMAPREADONLY e5 ON u.FRAUDSTATUS=e5.ENUMITEMNUMBER AND e5.ENUMTYPEFULLYQUALIFIEDNAME="RS.UserFraudStatus"
    LEFT JOIN dbo.ENUMMAPREADONLY e6 ON u.PREFERREDCONTACTTYPE=e6.ENUMITEMNUMBER AND e6.ENUMTYPEFULLYQUALIFIEDNAME="RS.ContactType"
    LEFT JOIN dbo.ENUMMAPREADONLY e7 ON u.REQUESTSOURCE=e7.ENUMITEMNUMBER AND e7.ENUMTYPEFULLYQUALIFIEDNAME="RS.DataType.Enums.LoanRequest.RequestSource"
    LEFT JOIN dbo.ENUMMAPREADONLY e8 ON u.CONTACTSETTING=e8.ENUMITEMNUMBER AND e8.ENUMTYPEFULLYQUALIFIEDNAME="RS.ContactSettingType"
    LEFT JOIN dbo.ENUMMAPREADONLY e9 ON u.TERMSACCEPTED=e9.ENUMITEMNUMBER AND e9.ENUMTYPEFULLYQUALIFIEDNAME="RS.TermsAcceptedOptions"
    LEFT JOIN dbo.ENUMMAPREADONLY e10 ON u.RSCUSTOMERSTATUS=e10.ENUMITEMNUMBER AND e10.ENUMTYPEFULLYQUALIFIEDNAME="RS.RSCustomerStatus"
    LEFT JOIN dbo.ENUMMAPREADONLY e11 ON u.RSCREDITSTATUS=e11.ENUMITEMNUMBER AND e11.ENUMTYPEFULLYQUALIFIEDNAME="RS.RSCreditStatus"
    LEFT JOIN dbo.ENUMMAPREADONLY e12 ON u.CURRENTIDENTITYSTATUS=e12.ENUMITEMNUMBER AND e12.ENUMTYPEFULLYQUALIFIEDNAME="RS.DataProvider.API.IdentityCheckResult"
    LEFT JOIN dbo.ENUMMAPREADONLY e13 ON u.CIFASSTATUS=e13.ENUMITEMNUMBER AND e13.ENUMTYPEFULLYQUALIFIEDNAME="RS.DataType.Enums.User.WarningStatusType"
    LEFT JOIN dbo.ENUMMAPREADONLY e14 ON u.PAYMENTWITHDRAWALSTATUS=e14.ENUMITEMNUMBER AND e14.ENUMTYPEFULLYQUALIFIEDNAME="RS.PaymentWithdrawalStatus"
    LEFT JOIN dbo.ENUMMAPREADONLY e15 ON u.OFASTATUS=e15.ENUMITEMNUMBER AND e15.ENUMTYPEFULLYQUALIFIEDNAME="RS.DataType.Enums.User.WarningStatusType"
    LEFT JOIN dbo.ENUMMAPREADONLY e16 ON u.WITHDRAWALPENDINGSTATUS=e16.ENUMITEMNUMBER AND e16.ENUMTYPEFULLYQUALIFIEDNAME="RS.PaymentPendingStatus"
    LEFT JOIN dbo.ENUMMAPREADONLY e17 ON u.FRAUDMATCHSTATUS=e17.ENUMITEMNUMBER AND e17.ENUMTYPEFULLYQUALIFIEDNAME="RS.DataType.Enums.User.WarningStatusType"
    LEFT JOIN dbo.ENUMMAPREADONLY e18 ON u.FCA_ACCEPTED=e18.ENUMITEMNUMBER AND e18.ENUMTYPEFULLYQUALIFIEDNAME="RS.TermsAcceptedOptions"
    LEFT JOIN dbo.ENUMMAPREADONLY e19 ON u.RA_ACCEPTED=e19.ENUMITEMNUMBER AND e19.ENUMTYPEFULLYQUALIFIEDNAME="RS.TermsAcceptedOptions"
    LEFT JOIN dbo.ENUMMAPREADONLY e20 ON u.REASONDECLINEDASLENDER=e20.ENUMITEMNUMBER AND e20.ENUMTYPEFULLYQUALIFIEDNAME="RS.LenderDeclineReason"
    LEFT JOIN dbo.ENUMMAPREADONLY e21 ON u.ACCOUNTTYPE=e21.ENUMITEMNUMBER AND e21.ENUMTYPEFULLYQUALIFIEDNAME="RSCore.RS.Users.AccountType"
    LEFT JOIN dbo.ENUMMAPREADONLY e22 ON u.CASESTUDYSTATUS=e22.ENUMITEMNUMBER AND e22.ENUMTYPEFULLYQUALIFIEDNAME="RS.CaseStudyStatus"
    LEFT JOIN dbo.ENUMMAPREADONLY e23 ON u.EOPSTATUS=e23.ENUMITEMNUMBER AND e23.ENUMTYPEFULLYQUALIFIEDNAME="RS.DataType.UserEOPStatus"
    LEFT JOIN dbo.ENUMMAPREADONLY e24 ON u.PEPSTATUS=e24.ENUMITEMNUMBER AND e24.ENUMTYPEFULLYQUALIFIEDNAME="RS.PEPWarningStatus"
  WHERE
    userId >= 3000000
  ;