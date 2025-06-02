# EPL 2024-25 Season Match Analysis

## Overview  
This project analyzes match data from the English Premier League (EPL) 2024-25 season to uncover insights such as team performance, key factors influencing match outcomes, and trends throughout the season.

## Data Source  
Matches dataset sourced from [Football Data](https://www.football-data.co.uk/englandm.php).  
*Note:* This project currently uses only match data, as I have yet to find or scrape a reliable players dataset.  
The main goal of this project is to showcase an end-to-end data engineering pipeline.

## Data Engineering Workflow

The project employs a modern Azure-based data engineering pipeline:

1. **Data Ingestion:**  
   Match data files are ingested directly from the source website and stored in **Azure Data Lake Storage (ADLS)** for scalable, secure storage.

2. **Data Transformation:**  
   Raw data is processed and transformed in **Azure Databricks** using Apache Spark. This step includes cleaning, feature engineering, and aggregation.

3. **Data Analysis:**  
   Transformed data is loaded into **Azure Synapse Analytics**, enabling advanced SQL analysis and integration with business intelligence tools for visualization.

## Features  
- End-to-end pipeline from data ingestion to analysis using Azure cloud services  
- Scalable processing with Databricks and Spark  
- Analytical queries and dashboards built in Synapse Analytics

## Folder Structure  
- `/datasets` – Raw and processed data files  
- `/notebooks` – Jupyter notebooks for exploratory analysis and modeling  
- `/queries` – SQL queries run in Azure Synapse Analytics to answer key business questions

## Project Structure & Workflow

1. Introduction to the project and architecture overview  
2. Explore data stored in the GitHub repository  
3. Azure Setup:  
   - Login to Azure portal  
   - Create Resource Group, Data Factory, Data Lake, Databricks, and Synapse accounts  
4. Data Ingestion:  
   - Use Azure Data Factory to move raw data from GitHub to Data Lake  
5. Data Processing:  
   - Connect Databricks to Data Lake  
   - Create Spark cluster and configure PySpark environment  
   - Load, clean, and transform data using PySpark  
   - Push transformed data back to Data Lake  
6. Data Analysis:  
   - Set up Synapse Analytics database, schema, views, and tables  
   - Run SQL queries answering key business questions such as:  
     - Average attendance for high-scoring games  
     - Referee with most matches and fouls average  
     - Goals and assists by position  
     - Home vs away performance comparisons  
     - Team with highest shot accuracy  

## Languages and Tools

- SQL  
- PySpark  
- Azure Data Lake Storage  
- Azure Data Factory  
- Azure Databricks  
- Azure Synapse Analytics  

## Getting Started

Clone the repository:

```bash
git clone https://github.com/jarrellimdata/epl2025-analysis.git
cd epl2025-analysis
```

## Credits
- Data provided by Football Data
- Azure services: Data Lake Storage, Data Factory, Databricks, Synapse Analytics
- Open-source libraries: Apache Spark, pandas, matplotlib
- Inspired by M3hrdad Dehghan; check out his GitHub and YouTube channel:
    - GitHub: https://github.com/M3hrdad-Dehghan/Analysis_of_Soccer_Data_with_SQL_in_Azure_Cloud_Services
    - YouTube: https://youtu.be/iOONpQTmotw

## Future Work
- Incorporate player-level data from the EPL 2024-25 season for deeper insights
- Include datasets from previous seasons (e.g., last 5–10 years) to analyze player and match trends over time
- Build interactive dashboards using Power BI or similar BI tools integrated with Synapse for high-level or seasonal overviews
- Automate the pipeline further using Azure Data Factory for orchestration