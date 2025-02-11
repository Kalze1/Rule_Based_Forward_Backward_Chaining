;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;; Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (Fact is_a_dish Beyaynet))
!(add-atom &kb (Fact is_fresh Beyaynet))
!(add-atom &kb (Fact has_multiple_kind Beyaynet))
!(add-atom &kb (Fact vegan Deborah))

!(add-atom &kb (True))

;; Rule Base

!(bind! &rb (new-space))

(= (food-rule)
    (-> (Fact is_a_dish $x)
        (Fact is_fresh $x)
        (Fact edible_food $x)))

(= (interesting_food_rule)
    (-> (Fact has_multiple_kind $x)
        (Fact edible_food $x)
        (Fact interesting_food $x)))

(= (likes-rule)
    (-> (Fact interesting_food $x)
        (Fact vegan $y)
        (Likes $y $x)))

!(add-reduct &rb (food-rule))
!(add-reduct &rb (interesting_food_rule))
!(add-reduct &rb (likes-rule))

;; Backward Chainer

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

;; Running Test

!(bc_bem (Likes Deborah Beyaynet) (fromNumber 3))

!(assertEqualToResult
    (bc_bem (Likes Deborah Beyaynet) (fromNumber 3))
    ((Likes Deborah Beyaynet)))
