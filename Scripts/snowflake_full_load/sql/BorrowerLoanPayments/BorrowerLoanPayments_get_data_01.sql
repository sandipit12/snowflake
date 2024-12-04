SELECT 
       [ID],
       [PaymentNumber],
       [SettlementDate],
       [PaymentDate],
       [Amount],
       [PaymentStatus],
       [OutstandingAmount],
       [SettlementCapital],
       [SettlementInterest],
       [CreditRateFee],
       [LoanFee],
       [PaymentType],
       [DDSubmissionDate],
       [SettlementStatus],
       [PaymentReference],
       [Active],
       [PeriodDate],
       [AssignmentFee],
       [OriginalPaymentID],
       [CreateDate],
       [GUID],
       [UserID],
       [BorrowerLoanID],
       [SequenceType],
       [IsEstimate],
       [RedemptionType],
       [RateFee],
       [FailureType],
       [FailedFlag],
       [FailedReason],
       [BankAccountID],
       [PartnerFeeContribution],
       [FileID],
       [PartnerFee],
       [Fee_Borrower],
       [Fee_SwapAdjustment],
       [Fee_FundingAdjustment],
       [Fee_Service],
       [Fee_Credit],
       [Fee_Partner],
       [Fee_ServiceAdjustment],
       [CreditFactorFee],
       [StandingOrderProcessingMethod],
       [StandingOrderRolloverRejected],
       [StandingOrderCashDate],
       [FailureChannel],
       [SubmissionAmount],
       [PFCover],
 /* metadata colums -- should not incldue in the hash_key */
    @@ServerName as Source_System,
    convert(date, getdate()) as Snapshot_Date,
/*--------------------------------------------------------------------
-- derived business key
-------------------------------------------------------------------- */
    HASHBYTES("SHA2_256",
      CONCAT_WS("|",
       [ID],
       [PaymentNumber],
       [SettlementDate],
       [PaymentDate],
       [Amount],
       [PaymentStatus],
       [OutstandingAmount],
       [SettlementCapital],
       [SettlementInterest],
       [CreditRateFee],
       [LoanFee],
       [PaymentType],
       [DDSubmissionDate],
       [SettlementStatus],
       [PaymentReference],
       [Active],
       [PeriodDate],
       [AssignmentFee],
       [OriginalPaymentID],
       [CreateDate],
       [GUID],
       [UserID],
       [BorrowerLoanID],
       [SequenceType],
       [IsEstimate],
       [RedemptionType],
       [RateFee],
       [FailureType],
       [FailedFlag],
       [FailedReason],
       [BankAccountID],
       [PartnerFeeContribution],
       [FileID],
       [PartnerFee],
       [Fee_Borrower],
       [Fee_SwapAdjustment],
       [Fee_FundingAdjustment],
       [Fee_Service],
       [Fee_Credit],
       [Fee_Partner],
       [Fee_ServiceAdjustment],
       [CreditFactorFee],
       [StandingOrderProcessingMethod],
       [StandingOrderRolloverRejected],
       [StandingOrderCashDate],
       [FailureChannel],
       [SubmissionAmount],
       [PFCover]
      )
    ) AS hash_key
 FROM 
       [dbo].[BorrowerLoanPayments]
  WHERE ID < 9200000;
