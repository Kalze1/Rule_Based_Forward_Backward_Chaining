;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;;  Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (Evaluation likes_food Ravi))
!(add-atom &kb (Evaluation is_food Idli))
!(add-atom &kb (Evaluation is_edible Idli))

!(add-atom &kb (True))


;;  Rule Base

!(bind! &rb (new-space))

(= (food-rule)
    (-> (Evaluation is_food $x)
        (Evaluation is_edible $x)
        (Evaluation edible_food $x)))

(= (likes-rule)
    (-> (Evaluation likes_food Ravi)
        (Evaluation edible_food $x)
        (Evaluation Ravi_likes  $x)))

!(add-reduct &rb (food-rule))
!(add-reduct &rb (likes-rule))


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

!(bc_bem (Evaluation Ravi_likes $what) (fromNumber 2))
