;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;;  Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (Evaluation has_pH_below_6 Spill))
!(add-atom &kb (Evaluation smells_like_vinegar Spill))
!(add-atom &kb (Evaluation reacts_with_metals $x))

!(add-atom &kb (True))


;;  Rule Base

!(bind! &rb (new-space))

(= (acidic-rule)
    (-> (Evaluation has_pH_below_6 $x)
        (Evaluation smells_like_vinegar $x)
        (Evaluation is_acidic $x)))

(= (acetic-acid-rule)
    (-> (Evaluation is_acidic $x)
        (Evaluation reacts_with_metals $x)
        (Evaluation is_acetic_acid $x)))

!(add-reduct &rb (acidic-rule))
!(add-reduct &rb (acetic-acid-rule))


;;  Backward Chainer

(: bc_bem (-> Atom Nat Atom))

;; Base case
(= (bc_bem $conclusion $depth)
   (match &kb $conclusion $conclusion))

;; Recursive step
(= (bc_bem $conclusion (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (let* (($premise1 (bc_bem $premise1 $k))
                 ($premise2 (bc_bem $premise2 $k)))
            $conclusion)))


;;  Running Test

!(bc_bem (Evaluation is_acetic_acid $what) (fromNumber 2))
