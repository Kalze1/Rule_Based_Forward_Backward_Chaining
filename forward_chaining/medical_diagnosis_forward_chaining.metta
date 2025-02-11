;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;;  Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (Evaluation has_fever Alice))
!(add-atom &kb (Evaluation has_cough Alice))
!(add-atom &kb (Evaluation has_sore_throat Alice))

!(add-atom &kb (True))


;;  Rule Base

!(bind! &rb (new-space))

(= (flu-diagnosis-rule)
    (-> (Evaluation has_fever $x)
        (Evaluation has_cough $x)
        (Evaluation diagnosis_is_flu $x)))

(= (extended-flu-rule)
    (-> (Evaluation diagnosis_is_flu $x)
        (Evaluation has_sore_throat $x)
        (Evaluation has_fatigue $x)))

!(add-reduct &rb (flu-diagnosis-rule))
!(add-reduct &rb (extended-flu-rule))


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

!(fc (Evaluation has_fever Alice) (fromNumber 2))
