
# ============================================================
# WEEK 1: DATA CLEANING AND PRELIMINARY ANALYSIS WITH R
# Project: Titanic Passenger Dataset
# Platform: Yuva Learn - Virtual R Data Analyst Internship
# ============================================================


# 1. PROJECT FOLDERS ------------------------------------------------

# Get current working directory
project_dir <- getwd()

# Define folder paths
data_dir <- file.path(project_dir, "Dataset")
graphs_dir <- file.path(project_dir, "Graphs")
outputs_dir <- file.path(project_dir, "Outputs")

# Create folders automatically
dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(graphs_dir, recursive = TRUE, showWarnings = FALSE)
dir.create(outputs_dir, recursive = TRUE, showWarnings = FALSE)

cat("Project Directory:", project_dir, "\n")
cat("Project folders created successfully.\n")


# 2. DOWNLOAD / IMPORT DATA -----------------------------------------

# Public Titanic dataset
data_url <- paste0(
  "https://raw.githubusercontent.com/",
  "rebeccabilbro/titanic/master/data/train.csv"
)

raw_file <- file.path(data_dir, "Original_Dataset.csv")

# Increase download timeout
options(timeout = 300)

# Download dataset if it does not already exist
if (!file.exists(raw_file) || file.info(raw_file)$size == 0) {
  
  temp_file <- tempfile(
    pattern = "titanic_",
    tmpdir = data_dir,
    fileext = ".csv"
  )
  
  download_status <- tryCatch(
    download.file(
      url = data_url,
      destfile = temp_file,
      method = "libcurl",
      mode = "wb",
      quiet = FALSE
    ),
    error = function(e) {
      stop("Dataset download failed: ", conditionMessage(e))
    }
  )
  
  if (download_status != 0 ||
      !file.exists(temp_file) ||
      file.info(temp_file)$size == 0) {
    stop("Dataset download failed. Check internet connection.")
  }
  
  if (!file.rename(temp_file, raw_file)) {
    file.copy(temp_file, raw_file, overwrite = TRUE)
    unlink(temp_file)
  }
  
  if (!file.exists(raw_file) || file.info(raw_file)$size == 0) {
    stop("Dataset could not be saved in the Dataset folder.")
  }
}

# Import dataset
titanic <- read.csv(
  raw_file,
  stringsAsFactors = FALSE,
  na.strings = c("", "NA")
)

# Verify dataset
cat("\nDATASET IMPORTED SUCCESSFULLY\n")
cat("Rows:", nrow(titanic), "\n")
cat("Columns:", ncol(titanic), "\n")

cat("\nFirst six rows:\n")
print(head(titanic))

cat("\nDataset Structure:\n")
str(titanic)

cat("\nDataset Summary:\n")
print(summary(titanic))


# 3. INITIAL DATA QUALITY CHECK --------------------------------------

# Check missing values before cleaning
missing_before <- data.frame(
  Variable = names(titanic),
  Missing_Count = colSums(is.na(titanic)),
  Missing_Percent = round(
    colMeans(is.na(titanic)) * 100, 2
  )
)

write.csv(
  missing_before,
  file.path(outputs_dir, "Missing_Values_Before.csv"),
  row.names = FALSE
)

cat("\nMISSING VALUES BEFORE CLEANING:\n")
print(missing_before)

# Check exact duplicate records
exact_duplicates <- sum(duplicated(titanic))

cat("\nExact Duplicate Rows:", exact_duplicates, "\n")

# Remove duplicate records
titanic <- titanic[!duplicated(titanic), ]


# 4. DATA CLEANING ---------------------------------------------------

# Remove Cabin because it has a high percentage of missing values
if ("Cabin" %in% names(titanic)) {
  titanic$Cabin <- NULL
}

# Age: Replace missing values with median
age_median <- median(titanic$Age, na.rm = TRUE)

if (is.finite(age_median)) {
  titanic$Age[is.na(titanic$Age)] <- age_median
}

# Function to calculate mode
mode_value <- function(x) {
  
  vals <- x[!is.na(x) & trimws(x) != ""]
  
  if (length(vals) == 0) {
    return(NA_character_)
  }
  
  names(sort(table(vals), decreasing = TRUE))[1]
}

# Embarked: Replace missing values with mode
embarked_mode <- mode_value(titanic$Embarked)

if (!is.na(embarked_mode)) {
  missing_embarked <- is.na(titanic$Embarked) |
    trimws(titanic$Embarked) == ""
  
  titanic$Embarked[missing_embarked] <- embarked_mode
}

# Convert categorical variables into factors
titanic$Survived <- factor(
  titanic$Survived,
  levels = c(0, 1),
  labels = c("No", "Yes")
)

titanic$Pclass <- factor(
  titanic$Pclass,
  levels = c(1, 2, 3),
  labels = c("First", "Second", "Third")
)

titanic$Sex <- factor(titanic$Sex)
titanic$Embarked <- factor(titanic$Embarked)

cat("\nDATA CLEANING COMPLETED.\n")


# 5. OUTLIER DETECTION -----------------------------------------------

# Function to detect outliers using IQR
outlier_flag <- function(x) {
  
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  
  iqr_value <- q3 - q1
  
  lower_limit <- q1 - 1.5 * iqr_value
  upper_limit <- q3 + 1.5 * iqr_value
  
  x < lower_limit | x > upper_limit
}

# Detect Age and Fare outliers
titanic$Age_Outlier <- outlier_flag(titanic$Age)
titanic$Fare_Outlier <- outlier_flag(titanic$Fare)

# Outlier summary
outlier_summary <- data.frame(
  Variable = c("Age", "Fare"),
  Outlier_Count = c(
    sum(titanic$Age_Outlier, na.rm = TRUE),
    sum(titanic$Fare_Outlier, na.rm = TRUE)
  )
)

write.csv(
  outlier_summary,
  file.path(outputs_dir, "Outlier_Summary.csv"),
  row.names = FALSE
)

cat("\nOUTLIER SUMMARY:\n")
print(outlier_summary)


# 6. NORMALIZATION ---------------------------------------------------

# Min-Max Normalization Function
min_max <- function(x) {
  
  rng <- range(x, na.rm = TRUE)
  
  if (diff(rng) == 0) {
    return(rep(0, length(x)))
  }
  
  (x - rng[1]) / (rng[2] - rng[1])
}

# Normalize Age and Fare
titanic$Age_Normalized <- min_max(titanic$Age)
titanic$Fare_Normalized <- min_max(titanic$Fare)

cat("\nNORMALIZATION COMPLETED.\n")


# 7. CATEGORICAL ENCODING --------------------------------------------

# Convert categorical variables into dummy variables
encoded <- model.matrix(
  ~ Sex + Pclass + Embarked - 1,
  data = titanic
)

encoded_df <- as.data.frame(encoded)

# Combine original and encoded data
encoded_output <- cbind(titanic, encoded_df)

cat("\nCATEGORICAL ENCODING COMPLETED.\n")


# 8. FINAL DATA QUALITY CHECK ----------------------------------------

# Missing values after cleaning
missing_after <- data.frame(
  Variable = names(titanic),
  Missing_Count = colSums(is.na(titanic)),
  Missing_Percent = round(
    colMeans(is.na(titanic)) * 100, 2
  )
)

write.csv(
  missing_after,
  file.path(outputs_dir, "Missing_Values_After.csv"),
  row.names = FALSE
)

# Save cleaned datasets
write.csv(
  titanic,
  file.path(data_dir, "Cleaned_Dataset.csv"),
  row.names = FALSE
)

write.csv(
  encoded_output,
  file.path(data_dir, "Cleaned_Encoded_Dataset.csv"),
  row.names = FALSE
)

cat("\nMISSING VALUES AFTER CLEANING:\n")
print(missing_after)


# 9. DESCRIPTIVE STATISTICS ------------------------------------------

# Select numeric variables
numeric_vars <- titanic[
  , sapply(titanic, is.numeric),
  drop = FALSE
]

# Calculate descriptive statistics
descriptive_stats <- data.frame(
  Variable = names(numeric_vars),
  
  Mean = sapply(
    numeric_vars, mean, na.rm = TRUE
  ),
  
  Median = sapply(
    numeric_vars, median, na.rm = TRUE
  ),
  
  SD = sapply(
    numeric_vars, sd, na.rm = TRUE
  ),
  
  Minimum = sapply(
    numeric_vars, min, na.rm = TRUE
  ),
  
  Maximum = sapply(
    numeric_vars, max, na.rm = TRUE
  )
)

write.csv(
  descriptive_stats,
  file.path(outputs_dir, "Descriptive_Statistics.csv"),
  row.names = FALSE
)

# Save summary output as text
writeLines(
  capture.output(summary(titanic)),
  file.path(outputs_dir, "Summary_Output.txt")
)

cat("\nDESCRIPTIVE STATISTICS:\n")
print(descriptive_stats)


# Survival analysis by gender
survival_by_sex <- prop.table(
  table(titanic$Sex, titanic$Survived),
  1
)

write.csv(
  as.data.frame.matrix(survival_by_sex),
  file.path(outputs_dir, "Survival_By_Sex.csv")
)

# Survival analysis by passenger class
survival_by_class <- prop.table(
  table(titanic$Pclass, titanic$Survived),
  1
)

write.csv(
  as.data.frame.matrix(survival_by_class),
  file.path(outputs_dir, "Survival_By_Class.csv")
)

cat("\nSURVIVAL RATE BY SEX:\n")
print(survival_by_sex)

cat("\nSURVIVAL RATE BY CLASS:\n")
print(survival_by_class)


# Correlation matrix
corr_data <- titanic[
  , c("Age", "SibSp", "Parch", "Fare")
]

correlation_matrix <- cor(
  corr_data,
  use = "pairwise.complete.obs"
)

write.csv(
  correlation_matrix,
  file.path(outputs_dir, "Correlation_Matrix.csv")
)

cat("\nCORRELATION MATRIX:\n")
print(correlation_matrix)


# 10. VISUALIZATIONS -------------------------------------------------

# GRAPH 1: Missing Values Before Cleaning
png(
  file.path(graphs_dir, "01_Missing_Values_Before.png"),
  width = 1200, height = 800, res = 140
)

barplot(
  missing_before$Missing_Count,
  names.arg = missing_before$Variable,
  las = 2,
  col = "steelblue",
  main = "Missing Values by Variable (Before Cleaning)",
  ylab = "Number of Missing Values",
  cex.names = 0.8
)

dev.off()


# GRAPH 2: Passenger Survival Distribution
png(
  file.path(graphs_dir, "02_Survival_Distribution.png"),
  width = 1000, height = 700, res = 140
)

barplot(
  table(titanic$Survived),
  col = c("tomato", "seagreen"),
  main = "Passenger Survival Distribution",
  xlab = "Survival Status",
  ylab = "Number of Passengers"
)

dev.off()


# GRAPH 3: Survival by Sex
png(
  file.path(graphs_dir, "03_Survival_By_Sex.png"),
  width = 1000, height = 700, res = 140
)

barplot(
  t(survival_by_sex),
  beside = TRUE,
  col = c("tomato", "seagreen"),
  main = "Survival Proportion by Sex",
  xlab = "Gender",
  ylab = "Survival Proportion",
  ylim = c(0, 1),
  legend.text = rownames(t(survival_by_sex)),
  args.legend = list(x = "topright")
)

dev.off()


# GRAPH 4: Passenger Age Distribution
png(
  file.path(graphs_dir, "04_Age_Histogram.png"),
  width = 1000, height = 700, res = 140
)

hist(
  titanic$Age,
  breaks = 25,
  col = "skyblue",
  main = "Passenger Age Distribution",
  xlab = "Age",
  ylab = "Frequency"
)

dev.off()


# GRAPH 5: Fare Boxplot
png(
  file.path(graphs_dir, "05_Fare_Boxplot.png"),
  width = 1000, height = 700, res = 140
)

boxplot(
  titanic$Fare,
  col = "gold",
  main = "Fare Distribution and Potential Outliers",
  ylab = "Fare"
)

dev.off()


# GRAPH 6: Correlation Heatmap
png(
  file.path(graphs_dir, "06_Correlation_Heatmap.png"),
  width = 1000, height = 800, res = 140
)

heatmap(
  correlation_matrix,
  Rowv = NA,
  Colv = NA,
  scale = "none",
  main = "Correlation Heatmap: Numeric Variables"
)

dev.off()


# GRAPH 7: Survival by Passenger Class
png(
  file.path(graphs_dir, "07_Survival_By_Class.png"),
  width = 1000, height = 700, res = 140
)

barplot(
  t(survival_by_class),
  beside = TRUE,
  col = c("tomato", "seagreen"),
  main = "Survival Proportion by Passenger Class",
  xlab = "Passenger Class",
  ylab = "Survival Proportion",
  ylim = c(0, 1),
  legend.text = rownames(t(survival_by_class)),
  args.legend = list(x = "topright")
)

dev.off()


# 11. TEXT OUTPUT FOR REPORT -----------------------------------------

analysis_report <- capture.output({
  
  cat("================================================\n")
  cat("TITANIC DATA CLEANING AND PRELIMINARY ANALYSIS\n")
  cat("WEEK 1 - YUVA LEARN INTERNSHIP\n")
  cat("================================================\n\n")
  
  cat("Dataset dimensions after duplicate removal:\n")
  cat(nrow(titanic), "rows x", ncol(titanic), "columns\n\n")
  
  cat("Structure:\n")
  str(titanic)
  
  cat("\nSummary:\n")
  print(summary(titanic))
  
  cat("\nDescriptive Statistics:\n")
  print(descriptive_stats)
  
  cat("\nMissing Values After Cleaning:\n")
  print(missing_after)
  
  cat("\nOutlier Summary:\n")
  print(outlier_summary)
  
  cat("\nCorrelation Matrix:\n")
  print(correlation_matrix)
  
  cat("\nSurvival Proportion by Sex:\n")
  print(survival_by_sex)
  
  cat("\nSurvival Proportion by Passenger Class:\n")
  print(survival_by_class)
  
})

writeLines(
  analysis_report,
  file.path(outputs_dir, "Analysis_Console_Output.txt")
)


# 12. PROJECT COMPLETION ---------------------------------------------

cat("\n")
cat("================================================\n")
cat("PROJECT COMPLETED SUCCESSFULLY!\n")
cat("================================================\n")

cat("\nTotal Records:", nrow(titanic), "\n")
cat("Total Columns:", ncol(titanic), "\n")

cat("\nGenerated Folders:\n")
cat("1. Dataset - Original and cleaned datasets\n")
cat("2. Graphs - 7 visualization images\n")
cat("3. Outputs - Statistical reports and analysis\n")

cat("\nProject Location:\n")
cat(project_dir, "\n")

cat("\nAll analysis tasks completed.\n")
