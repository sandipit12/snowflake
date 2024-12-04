CREATE OR REPLACE TABLE staging.dbo_LoanRequests(
	PK_LoanRequest int NOT NULL,
	CreateDate datetime NULL,
	UpdateDate datetime NULL,
	Amount bigint NULL,
	Term int NULL,
	Purpose varchar(255) NULL,
	PurposeOther varchar(2048) NULL,
	RequestStatus int NULL,
	AdminUser int NULL,
	CreditRate int NULL,
	CreditStatus int NULL,
	OriginalAmount bigint NULL,
	OriginalTerm int NULL,
	SuggestedPass INT NULL,
	AppComplete INT NULL,
	CompletionDate datetime NULL,
	RequestSource int NULL,
	SharingOptIn int NULL,
	RequestType int NULL,
	FK_ConsolidationLoan int NULL,
	FeeRebate int NULL,
	CRAdjustment bigint NULL,
	ApprovalDate datetime NULL,
	FacilityAmount bigint NULL,
	FacilityDate datetime NULL,
	LoanSecurity int NULL,
	BaseRate int NOT NULL,
	SecondaryRate int NOT NULL,
	DocumentGUID VARCHAR(130) NULL,
	RequestGUID VARCHAR(130) NULL,
	CreditQueue int NOT NULL,
	FeeType int NULL,
	LoanFeeRebate bigint NULL,
	AffiliateFee bigint NULL,
	AffiliateFeeRebate bigint NULL,
	CategoryFee bigint NULL,
	LoanFee bigint NULL,
	FixedAPR int NULL,
	LockApprovalTerm int NULL,
	OriginatingRequest int NULL,
	FK_AutoApproval_RuleSet int NULL,
	UnderwritingStatus int NULL,
	FirstContact int NULL,
	FirstContactDate datetime NULL,
	FirstContactStaff int NULL,
	FirstContactRequestStatus int NULL,
	FirstContactCreditStatus int NULL,
	TargetFirstContactDate datetime NULL,
	CreditDecision int NULL,
	ReasonForCancellation int NULL,
	LoanPurpose int NULL,
	CreditCategory varchar(50) NULL,
	CreditCategoryID int NULL,
	InboundCalls int NULL,
	CreditFee bigint NULL,
	Repayment_monthly bigint NULL,
	Repayment_total bigint NULL,
	DirectDebitDay int NULL,
	LoanRepaymentType int NULL,
	FK_PrimaryUserID int NULL,
	RSInterestRate int NULL,
	BorrowerInterestRate int NULL,
	DirectDebitMonth int NULL,
	ThirdPartyAllocation int NULL,
	APRType int NULL,
	BusinessSector int NULL,
	BusinessSubSector int NULL,
	BusinessLoanUse int NULL,
	PaymentCreditRate int NULL,
	ContractsSeen int NULL,
	LoanNumber varchar(255) NULL,
	UserDDDay int NULL,
	ContractSignedDate datetime NULL,
	UserDDMonth int NULL,
	FundingSource int NULL,
	FundingRate int NULL,
	PreDivertAPR int NULL,
	TrackingSource varchar(255) NULL,
	TrackingPromo varchar(200) NULL,
	TrackingCreative varchar(200) NULL,
	FK_AffiliateSubAccount int NULL,
	RetailDeposit bigint NULL,
	DepositFee bigint NULL,
	OutPaymentFee bigint NULL,
	Rate_Borrower int NULL,
	Rate_Funding int NULL,
	Rate_Credit int NULL,
	Rate_Service int NULL,
	Rate_CostOfFunds int NULL,
	Rate_Swap int NULL,
	Rate_SwapAdjustment int NULL,
	Rate_Partner int NULL,
	QuoteValidDate datetime NULL,
	ProcessType int NOT NULL,
	Commitment_DaysValid int NOT NULL,
	LoanSubsidy bigint NULL,
	FacilityCreditStatus int NULL,
	ThirdPartyReference varchar(100) NULL,
	CallCreditScore int NULL,
	EquifaxScore int NULL,
	FundingProductID int NULL,
	FK_CarPromotionApplicationID int NULL,
	RequirePreApproval INT NULL,
	PartnerFeeContribution bigint NULL,
	ThirdPartyScore int NULL,
	Originator int NULL,
	Regulated int NULL,
	CommitmentType int NOT NULL,
	SubsidyType int NULL,
	LoanAgreementType int NOT NULL,
	FK_InfoGraphicVersion int NULL,
	BrokerDeclarationAccepted INT NOT NULL,
	ConfirmBrokerFormDate datetime NULL,
	SharingSent INT NOT NULL,
	TotalCreditRateFee bigint NULL,
	LoanFee_Subsidy bigint NULL,
	CreditFactorFee_Subsidy bigint NULL,
	ThirdPartyName varchar(100) NULL,
	PreApproved INT NULL,
	BusinessSectorDescription nvarchar(1500) NULL,
	ChangeInCircumstances INT NULL,
	IntroducerFee bigint NULL,
	IntroducerFeeRebate bigint NULL,
	SecurityProvided INT NULL,
	IsReApplication INT NULL,
	QuoteAffordabilityApprove INT NULL,
	AffordabilityApprove INT NULL,
	DecisionRoute int NULL,
	DocumentFee bigint NULL,
	PurchaseFee bigint NULL,
	UseRolling INT NOT NULL,
	DaysBeforeFirstPayment int NULL,
	Channel int NULL,
	PricingChannel int NULL,
	ApolloRoute int NULL,
	LoanFeesId int NULL,
	/* MetaData Columns*/
	Source_System varchar(100) null,
	Snapshot_Date datetime null,	
	hash_key varchar(200) NOT NULL,
	PRIMARY KEY (PK_LoanRequest)
 );
 

