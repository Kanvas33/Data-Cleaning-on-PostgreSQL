# Housing Data Cleaning and Transformation project <a href="https://www.postgresql.org" target="_blank" rel="noreferrer"> <img src="https://raw.githubusercontent.com/devicons/devicon/master/icons/postgresql/postgresql-original-wordmark.svg" alt="postgresql" width="40" height="40"/> </a> 


## Check the code by clicking on the link below:
- ['Data Cleaning Project'](https://github.com/Kanvas33/Data-Cleaning-on-PostgreSQL/blob/main/Data%20Cleaning(nashville_housing).sql)


## Project Overview

This repository contains **SQL code for cleaning and transforming housing data in Nashville, USA**. The code is designed to process a table named `nashville_housing`, which holds **information about housing properties** in Nashville. This README provides an overview of the project's **objectives, workflow, achievements, insights gained, and a conclusion**.

## Project Objectives

- Import CSV data into the `nashville_housing` table.
- Clean and transform the data within the table.
- Address missing values in the `propertyaddress` column.
- Split the `owneraddress` column into separate columns for state, city, and street.
- Standardize values in the `soldasvacant` column.
- Identify and remove duplicate records.
- Optimize the table structure by dropping unnecessary columns.
- Provide documentation and insights about the data cleaning process.

## Project Workflow

- **Table Creation**: A table named `nashville_housing` is created to hold the data from a CSV file.

- **Data Import**: The CSV data is imported into the `nashville_housing` table.

- **Data Cleaning**:
  Populating missing `propertyaddress` values based on `parcelid`.
  Splitting `owneraddress` into state, city, and street.
  Standardizing values in the `soldasvacant` column.
  Identifying and removing duplicate records.
  Dropping the `owneraddress` column.

- **Database Backup**: Guidelines on how to create a database backup using pgAdmin are provided in the comments.

## Achievements and Insights

- Achieved successful data import and cleaning in the `nashville_housing` table.
- Addressed missing `propertyaddress` values using `parcelid` references.
- Split `owneraddress` into individual columns for better data organization.
- Standardized values in the `soldasvacant` column for consistency.
- Removed duplicate records based on specific columns.
- Optimized the table structure by dropping the `owneraddress` column.

## Conclusion

This project demonstrates **effective data cleaning and transformation techniques using SQL**. By following the workflow outlined in the code, the `nashville_housing` table is now **ready for further analysis or reporting**. Feel free to explore the code and adapt it to your specific data cleaning needs.

#### For any questions or further information, please feel free to contact me here or at jeff.farias@gmail.com.
