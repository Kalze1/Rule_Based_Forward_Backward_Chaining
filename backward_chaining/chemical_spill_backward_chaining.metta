;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;;  Knowledge Base: Chemical Properties

!(bind! &kb (new-space))

!(add-atom &kb (HasProperty Spill pH_below_7))
!(add-atom &kb (HasProperty Spill turns_litmus_red))
!(add-atom &kb (HasProperty Spill pH_below_2))
!(add-atom &kb (HasProperty Spill damages_organic_materials))
!(add-atom &kb (HasProperty Spill toxic))
!(add-atom &kb (True))


;;  Rule Base: More Detailed Chemical Classification

!(bind! &rb (new-space))

(= (acidic-rule)
    (-> (HasProperty $x pH_below_7)
        (HasProperty $x turns_litmus_red)
        (Classification $x acidic)))

(= (strong-acid-rule)
    (-> (Classification $x acidic)
        (HasProperty $x pH_below_2)
        (Classification $x strong_acid)))


(= (corrosive-rule)
    (-> (Classification $x strong_acid)
        (HasProperty $x damages_organic_materials)
        (Classification $x corrosive)))

(= (dangerous-material-rule)
    (-> (Classification $x corrosive)
        (HasProperty $x toxic)
        (Classification $x dangerous)))

!(add-reduct &rb (acidic-rule))
!(add-reduct &rb (strong-acid-rule))
!(add-reduct &rb (corrosive-rule))
!(add-reduct &rb (dangerous-material-rule))


;;  Backward Chainer

(: bc_bem (-> Atom Nat Atom))

(= (bc_bem $conclusion $depth)
   (match &kb $conclusion $conclusion))

(= (bc_bem $conclusion (S $k))
   (match &rb (-> $premise1 $premise2 $conclusion)
          (let* (($premise1 (bc_bem $premise1 $k))
                 ($premise2 (bc_bem $premise2 $k)))
            $conclusion)))


;;  Running Test
;; Test 1: Is a spill dangerous? with depth 2
!(Test 1: Is a spill dangerous? with depth 2)
!(bc_bem (Classification Spill dangerous) (fromNumber 2))

;; Test 2: Is a spill dangerous? with depth 3
!(Test 2: Is a spill dangerous? with depth 4)
!(bc_bem (Classification Spill dangerous) (fromNumber 4))
