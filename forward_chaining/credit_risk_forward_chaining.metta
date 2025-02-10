;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;;  Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (Evaluation has_credit_score_above_750 John))
!(add-atom &kb (Evaluation has_stable_income John))
!(add-atom &kb (Evaluation meets_bank_criteria John))

!(add-atom &kb (True))


;;  Rule Base

!(bind! &rb (new-space))

(= (credit-score-rule)
    (-> (Evaluation has_credit_score_above_750 $x)
        (Evaluation has_stable_income $x)
        (Evaluation loan_eligibility $x)))

(= (loan-interest-rule)
    (-> (Evaluation loan_eligibility $x)
        (Evaluation meets_bank_criteria $x)
        (Evaluation loan_interest_rate_10_percent $x)))

!(add-reduct &rb (credit-score-rule))
!(add-reduct &rb (loan-interest-rule))


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

!(fc (Evaluation has_credit_score_above_750 John) (fromNumber 2))
