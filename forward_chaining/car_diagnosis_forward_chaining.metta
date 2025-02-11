;; Define cast functions between Nat and Number
(: fromNumber (-> Number Atom))
(= (fromNumber $n) (if (<= $n 0) Z (S (fromNumber (- $n 1)))))

;;  Knowledge Base

!(bind! &kb (new-space))

!(add-atom &kb (Evaluation car_wont_start Car_1111))
!(add-atom &kb (Evaluation fuel_tank_not_empty Car_1111))

!(add-atom &kb (True))


;;  Rule Base

!(bind! &rb (new-space))

(= (fuel-issue-rule)
   (-> (Evaluation car_wont_start $x)
       (Evaluation fuel_tank_not_empty $x)
       (Evaluation issue_is_not_fuel $x)))

(= (battery-issue-rule)
    (-> (Evaluation car_wont_start $x)
        (Evaluation issue_is_not_fuel $x)
        (Evaluation issue_is_battery $x)))

!(add-reduct &rb (fuel-issue-rule))
!(add-reduct &rb (battery-issue-rule))


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
!(fc (Evaluation car_wont_start Car_1111) (fromNumber 2))

;; No conclusion will be reached because there is no supporting evidence for Car_1112 in the knowledge base
!(fc (Evaluation car_wont_start Car_1112) (fromNumber 2))
