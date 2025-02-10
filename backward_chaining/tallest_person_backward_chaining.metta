;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;;  Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (Evaluation taller_than John Kim))
!(add-atom &kb (Evaluation taller_than Kim EveryoneElse))

!(add-atom &kb (True))


;;  Rule Base

!(bind! &rb (new-space))

(= (tallest-rule-1)
    (-> (Evaluation taller_than $x $y)
        (Evaluation taller_than $y EveryoneElse)
        (Evaluation tallest $x)))

!(add-reduct &rb (tallest-rule-1))


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

!(bc_bem (Evaluation tallest $who) (fromNumber 2))
