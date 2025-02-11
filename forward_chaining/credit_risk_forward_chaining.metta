;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;;  Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (HasCreditScore Abebe above_750))
!(add-atom &kb (HasStableIncome Abebe))
!(add-atom &kb (HasLowDebt Abebe))
!(add-atom &kb (OwnsAssets Abebe house))
!(add-atom &kb (HasGoodRepaymentHistory Abebe))
!(add-atom &kb (HasRequiredDocuments Abebe))

!(add-atom &kb (HasStableIncome Hana))
!(add-atom &kb (HasHighDebt Hana))
!(add-atom &kb (OwnsAssets Hana none))
!(add-atom &kb (HasLoanAmount Hana medium))
!(add-atom &kb (HasLoanTerm Hana long))
!(add-atom &kb (HasDebtToIncomeRatio Hana risky))
!(add-atom &kb (HasRequiredDocuments Hana))

!(add-atom &kb (True))

;;  Rule Base

!(bind! &rb (new-space))

(= (loan-eligibility-rule)
    (-> (HasCreditScore $x above_750)
        (HasStableIncome $x)
        (LoanEligible $x)))

(= (bank-criteria-rule)
    (-> (LoanEligible $x)
        (HasLowDebt $x)
        (MeetsBankCriteria $x)))

(= (premium-loan-rule)
    (-> (MeetsBankCriteria $x)
        (HasGoodRepaymentHistory $x)
        (MeetsPremiumBankCriteria $x)))

(= (premium-loan-approval-rule)
    (-> (MeetsPremiumBankCriteria $x)
        (HasRequiredDocuments $x)
        (PremiumLoanApproved $x)))

(= (loan-approval-rule)
    (-> (MeetsBankCriteria $x)
        (HasRequiredDocuments $x)
        (LoanApproved $x)))

!(add-reduct &rb (loan-eligibility-rule))
!(add-reduct &rb (bank-criteria-rule))
!(add-reduct &rb (premium-loan-rule))
!(add-reduct &rb (loan-approval-rule))
!(add-reduct &rb (premium-loan-approval-rule))


;;  Forward Chainer

;; Base case
(= (fc $premise $depth) $premise)

;; Recursive steps
(= (fc $premise1 (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (match &kb $premise2 (fc $conclusion $k))))

(= (fc $premise2 (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (match &kb $premise1 (fc $conclusion $k))))

;;  Running Test

!(fc (HasCreditScore Abebe above_750) (fromNumber 5))

; Loan will not be approved because Hana does not fulfill the "HasLowDebt" requirement in the bank criteria rule
!(fc (HasCreditScore Hana above_750) (fromNumber 5))
