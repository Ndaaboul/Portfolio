# PowerBI Dashboard for the Comprehensive Michigan Counties Analysis Dashboard



## Problem Statement

Individuals and families often face significant challenges when deciding where to live, particularly when considering factors such as crime rates, rental costs, and commuting expenses. In Michigan, the lack of a comprehensive, user-friendly tool that integrates these critical factors makes it difficult for people to make informed decisions about where to reside relative to their place of employment. This project aims to address this gap by developing an interactive dashboard that provides detailed, comparative analysis of all Michigan counties, based on crime rates, average rent, and commuting costs, enabling users to make well-informed living choices.


### Steps followed 

- Step 1 : Data was sourced from www.huduser.gov, simplemaps.com, and ucr.fbi.gov.
- Step 2 : Excel was utilized to clean and preprocess the raw data.
- Step 3 : SQL Server Management Studio (SSMS) was employed to:    
  - Query the cleaned data
  -  Calculate distances between different counties
  -  Calculate distances between different cities
  -  Compute the average crime rate per county and per city
  -  Further clean and prepare the data using SQL queries.

- Step 4 : The processed data was imported into Power BI.

- Step 5 : Relationships between tables were established in Power BI to ensure data integrity and usability.

- Step 6 : A new column was created to categorize the crime rate into groups for better and easier visualization.

        CrimeRateGroup = 
        SWITCH(
            TRUE(),
            County_Level1[CrimeRate_County] = 0, "No value",
            County_Level1[CrimeRate_County] > 0 && County_Level1[CrimeRate_County] <= 3, "Under 3",
            County_Level1[CrimeRate_County] > 3 && County_Level1[CrimeRate_County] <= 6, "3-6%",
            County_Level1[CrimeRate_County] > 6 && County_Level1[CrimeRate_County] <= 10, "6-10%",
            County_Level1[CrimeRate_County] > 10, "Above 10%")

    ![CrimeRateGroup](https://github.com/Ndaaboul/Portfolio/assets/123441867/d0e4b3cc-3c94-41c1-ae4a-10f106d2d0fa)


- Step 7 :Slicers were added for the following parameters:
  - County Name
  - Gas Price
  - MPG (Miles Per Gallon)

![Slicers](https://github.com/Ndaaboul/Portfolio/assets/123441867/8e9a653a-d91e-445a-96c1-da665ebdf44b)

- Step 8 : A TravelCost measure was created using DAX (Data Analysis Expressions) to be used in the visualization.
       
        TravelCost1 = 
        
        VAR SelectedCounty = SELECTEDVALUE(County_Level1[County1])
        VAR SelectedGasPrice = SELECTEDVALUE('Gas Price'[Gas price])
        VAR SelectedMPG = SELECTEDVALUE(mpg[mpg])
        
        RETURN
        SUMX(
            FILTER(
                County_Level1,
                County_Level1[County1] = SelectedCounty
            ),
            ((County_Level1[Distance_County_Mile] / SelectedMPG) * SelectedGasPrice)*26)
        





- Step 9 : Various visualizations were added to the dashboard:
    -  Line and Stacked Column Chart
    ![Stacked Column](https://github.com/Ndaaboul/Portfolio/assets/123441867/0a9a69a3-f6ab-40d1-8ff8-0e790e440e8f)

    -  Matrix Table
    ![Matrix](https://github.com/Ndaaboul/Portfolio/assets/123441867/e9f8c5a0-54c1-4501-a72c-75258c73ee34)

    -  Filled Map
    ![Map](https://github.com/Ndaaboul/Portfolio/assets/123441867/4c8c3bf0-e4ba-4592-9b76-a7b0acc79b61)

    -  Multi-Row Card

- Step 10 : For better visibility, a separate page was created (duplicated) for each room size:
    -   Studio
    -   One Bedroom
    -   Two Bedroom
    -   Three Bedroom
    -   Four Bedroom
    ![Pages](https://github.com/Ndaaboul/Portfolio/assets/123441867/7e019ba5-c4a9-4947-9db7-147a601eec10)

- Step 11 : A main page was designed.
- Step 12 : Page Navigator buttons were added to enable users to move between pages based on the type of apartment they are looking for.
![Mainpage](https://github.com/Ndaaboul/PortfolioProjects/assets/123441867/0cc946f3-f31e-4b3f-89db-d1851811e55a)

- Step 13 :By following these steps, the project successfully developed an interactive dashboard that allows users to filter by job location, input current gas prices and MPG, and generate detailed comparative reports on the cost of living across Michigan counties.
![Full Dashboard](https://github.com/Ndaaboul/Portfolio/assets/123441867/9c00d315-5f31-4e34-ac1b-c43c0ddc1c0c)



