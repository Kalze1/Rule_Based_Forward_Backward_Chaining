# Rule-Based Forward and Backward Chaining Examples in MeTTa

This repository contains implementations of **Forward Chaining** and **Backward Chaining** using **Rule-Based Reasoning** in the MeTTa language.

## 📌 Structure

```
📂 Rule_Based_Forward_Backward_Chaining
│── 📂 forward_chaining
│   │── crime_detection_forward_chaining.metta
│   │── credit_risk_forward_chaining.metta
│   │── car_diagnosis_forward_chaining.metta
│   │── medical_diagnosis_forward_chaining.metta
│── 📂 backward_chaining
│   │── tallest_person_backward_chaining.metta
│   │── ravi_likes_idli_backward_chaining.metta
│   │── chemical_spill_backward_chaining.metta
│── README.md
```

## 🔹 What is a Rule-Based System?
A **Rule-Based System** applies logical rules to **known facts** to **infer new facts**.
- **Forward Chaining** starts from **known facts** and **applies rules** to reach **a conclusion**.
- **Backward Chaining** starts with **a goal (conclusion)** and **works backward** to see if the facts support it.

## 🔹 Forward Chaining (Data-Driven Inference)
1. **Crime Detection** – Determines if someone is a criminal based on illegal weapon sales.
2. **Credit Risk Assessment** – Determines loan approval based on credit score and income.
3. **Car Diagnosis** – Identifies car issues (fuel problem or battery issue).
4. **Medical Diagnosis** – Diagnoses diseases based on symptoms.

## 🔹 Backward Chaining (Goal-Driven Inference)
1. **Tallest Person Deduction** – Determines if John is the tallest person.
2. **Ravi Likes Idli** – Traces back if Ravi likes Idli based on logical deduction.
3. **Chemical Spill Identification** – Identifies a chemical spill by tracing backward from expected properties.

## 🚀 How to Install and Run

### **1️⃣ Install Hyperon (MeTTa Interpreter)**
To run these examples, you need to install **Hyperon**, which includes the MeTTa language. Install it using:
```sh
pip install hyperon
```

### **2️⃣ Run a Specific Example**
To execute an example, use the **MeTTa interpreter**:
```sh
metta forward_chaining/crime_detection_forward_chaining.metta
```
or
```sh
metta backward_chaining/tallest_person_backward_chaining.metta
```

## 📌 Contribution
If you would like to contribute or improve this project, feel free to fork the repository and submit a pull request!

## 📌 License
This project is open-source and available for learning and experimentation purposes.

---

**Developed as part of an exploration into Rule-Based Systems in MeTTa.** 🚀

