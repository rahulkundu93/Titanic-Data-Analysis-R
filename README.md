# Titanic Dataset – Data Cleaning and Preliminary Analysis Using R

## Virtual R Data Analyst Internship | Yuva Learn Platform, Pune

![R Programming](https://img.shields.io/badge/Language-R-blue)
![Project](https://img.shields.io/badge/Project-Data%20Analysis-green)
![Status](https://img.shields.io/badge/Status-Completed-success)
![Internship](https://img.shields.io/badge/Internship-Week%201-orange)

## 📌 Project Overview

This project focuses on **Data Cleaning, Data Preprocessing, and Exploratory Data Analysis (EDA)** using R programming.

The Titanic Passenger Dataset is used to demonstrate practical data analytics techniques, including handling missing values, detecting outliers, normalizing numerical variables, encoding categorical variables, generating descriptive statistics, and performing correlation analysis.

The project was completed as part of Week 1 of the Virtual R Data Analyst Internship organized by Yuva Learn Platform, Pune.

## 🎯 Project Objectives

- Import and understand a real-world dataset using R.
- Identify and handle missing values.
- Detect and manage potential outliers.
- Perform data normalization.
- Encode categorical variables.
- Generate descriptive statistics.
- Perform correlation analysis.
- Create meaningful data visualizations.
- Extract preliminary insights from the dataset.

## 📊 Dataset Information

**Dataset:** Titanic Passenger Dataset

**Source:** [Titanic Dataset – Kaggle](https://www.kaggle.com/competitions/titanic)

**Dataset Size:** 891 passenger records and 12 original columns.

Important variables include:

| Variable | Description |
|---|---|
| PassengerId | Unique passenger identifier |
| Survived | Survival status (0/1) |
| Pclass | Passenger ticket class |
| Sex | Passenger gender |
| Age | Passenger age |
| SibSp | Siblings/spouses aboard |
| Parch | Parents/children aboard |
| Fare | Passenger ticket fare |
| Embarked | Port of embarkation |

## 🛠️ Technologies and Tools

- **Programming Language:** R
- **IDE:** RStudio
- **Dataset Format:** CSV
- **Data Visualization:** Base R Graphics
- **Version Control:** Git and GitHub

## 🔍 Project Implementation

### 1. Data Import and Inspection
- Imported the Titanic dataset using `read.csv()`.
- Examined the first records using `head()`.
- Inspected data structure using `str()`.
- Generated statistical summaries using `summary()`.

### 2. Data Cleaning
- Identified missing values using `is.na()` and `colSums()`.
- Applied median imputation for missing Age values.
- Applied mode imputation for missing Embarked values.
- Excluded Cabin due to a high percentage of missing values.
- Checked and removed exact duplicate records, if present.

### 3. Outlier Detection
- Used the Interquartile Range (IQR) method.
- Identified potential outliers in Age and Fare.
- Retained flagged observations for further investigation.

### 4. Data Normalization
- Applied Min-Max normalization.
- Created `Age_Normalized` and `Fare_Normalized` variables.

### 5. Categorical Encoding
- Converted categorical variables into factors.
- Used `model.matrix()` for one-hot encoding.

### 6. Exploratory Data Analysis
- Survival distribution analysis.
- Age distribution histogram.
- Fare distribution boxplot.
- Survival analysis by gender.
- Survival analysis by passenger class.
- Correlation heatmap.

## 📈 Key Findings

| Analysis | Result |
|---|---:|
| Total Passengers | 891 |
| Survived | 342 |
| Did Not Survive | 549 |
| Missing Age Values | 177 |
| Missing Cabin Values | 687 |
| Missing Embarked Values | 2 |
| Age Outliers | 66 |
| Fare Outliers | 116 |

### Survival Analysis

- Female survival rate: **74.20%**
- Male survival rate: **18.89%**
- First-class survival rate: **62.96%**
- Second-class survival rate: **47.28%**
- Third-class survival rate: **24.24%**

The analysis indicates substantial differences in observed survival proportions across gender and passenger classes.

## 📂 Project Folder Structure

```text
Titanic-Data-Analysis-R/
│
├── README.md
│
├── Dataset/
│   ├── Original_Dataset.csv
│   ├── Cleaned_Dataset.csv
│   └── Cleaned_Encoded_Dataset.csv
│
├── R_Code/
│   └── Week1_Data_Analysis.R
│
├── Graphs/
│   ├── 01_Missing_Values_Before.png
│   ├── 02_Survival_Distribution.png
│   ├── 03_Survival_By_Sex.png
│   ├── 04_Age_Histogram.png
│   ├── 05_Fare_Boxplot.png
│   ├── 06_Correlation_Heatmap.png
│   └── 07_Survival_By_Class.png
│
├── Outputs/
│   ├── Analysis_Console_Output.txt
│   ├── Descriptive_Statistics.csv
│   ├── Correlation_Matrix.csv
│   ├── Missing_Values_Before.csv
│   ├── Missing_Values_After.csv
│   ├── Outlier_Summary.csv
│   ├── Survival_By_Sex.csv
│   └── Survival_By_Class.csv
│
└── Report/
    └── Week1_Titanic_Final_Report.docx
```

## ▶️ How to Run the Project

1. Install [R](https://cran.r-project.org/).
2. Install [RStudio](https://posit.co/download/rstudio-desktop/).
3. Clone or download this GitHub repository.
4. Open the project folder in RStudio.
5. Open `R_Code/Week1_Data_Analysis.R`.
6. Set the working directory to the project root folder.
7. Run the complete R script.

The script downloads the dataset automatically if the original CSV is not already available in the Dataset folder.

No additional R packages are required for the supplied base R implementation.

## 📑 Project Deliverables

- Complete R source code.
- Original and cleaned datasets.
- Data analysis graphs and visualizations.
- Statistical analysis outputs.
- Final Word project report.

## 🎓 Internship Information

**Internship:** Virtual R Data Analyst Internship  
**Organization:** Yuva Learn Platform  
**Location:** Pune, Maharashtra  
**Task:** Week 1 – Data Cleaning and Preliminary Analysis with R

## 👨‍💻 Author

**Name:** [Your Full Name]

**Role:** R Data Analyst Intern

**Project:** Week 1 Internship Assignment

## 📌 Acknowledgement

I would like to thank Yuva Learn Platform for providing this internship opportunity and practical exposure to R programming, data cleaning, preprocessing, statistical analysis, and data visualization.

---

⭐ If you find this project useful, feel free to explore the code and analysis.

**#RProgramming #DataAnalytics #DataCleaning #ExploratoryDataAnalysis #YuvaLearn**
