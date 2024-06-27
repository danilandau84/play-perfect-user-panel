

# Play Perfect - user_panel 

### Project Descrition:

This project proccess and tranform user's data by modeling big query raw data table.
Also, provide an API service, that expose GetAttribute to client,with an emphasis on efficiency.

### Project is composed of:

1. **Pipeline**: 
   
    **A.** DBT modeling data, each desired attribute is a stage/view. A join of all stages forms the desired user-panel table. as described on the following graph: ![model graph](/user_panel_graph.PNG)
    
    **B.** data loading python script:  load user_panel table into indexed Postgresql table (deployed on GCP) for efficient fetching 


2. **Api-Service**: Web api Expose GetAttribute by player Id, using FastApi web framework and psycopg2 Connection Pool supporting multiple paralel requests to interact with Postgresql


### Run instraction:

 0. git clone https://github.com/danilandau84/play-perfect-user-panel
dbt modeling: 
 1. pip install -r requirements.txt
 2. dbt init
 3. dbt run

Data loading: 
 1. python data_load.py 

Api Service:
 1.  python api-service.py
 
 





