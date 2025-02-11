;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))


;;  Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (Evaluation is_american Colonel))
!(add-atom &kb (Evaluation sold_weapons Colonel))
!(add-atom &kb (Evaluation enemy_weapon_possession Nono))
!(add-atom &kb (Evaluation enemy_of_america Nono))
!(add-atom &kb (Evaluation owns_missiles Nono))

!(add-atom &kb (True))


;;  Rule Base

!(bind! &rb (new-space))

(= (illegal-weapon-sale-rule)
    (-> (Evaluation is_american $x)
        (Evaluation sold_weapons $x)
        (Evaluation illegal_sale $x)))

(= (enemy-has-weapons-rule)
    (-> (Evaluation enemy_of_america $y)
        (Evaluation owns_missiles $y)
        (Evaluation enemy_weapon_possession $y)))

(= (crime-final-rule)
    (-> (Evaluation illegal_sale $x)
        (Evaluation enemy_weapon_possession $y)
        (Diagnosis $x criminal)))

(= (enemy-owns-dangerous-weapons-rule)
    (-> (Evaluation enemy_of_america $y)
        (Evaluation owns_missiles $y)
        (Evaluation enemy_weapon_possession $y)))


!(add-reduct &rb (illegal-weapon-sale-rule))
!(add-reduct &rb (enemy-has-weapons-rule))
!(add-reduct &rb (crime-final-rule))
!(add-reduct &rb (enemy-owns-dangerous-weapons-rule))



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

!(fc (Evaluation is_american Colonel) (fromNumber 2))

