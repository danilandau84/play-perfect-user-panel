

# Play Perfect - user_panel 

## Project Descrition:
### Project is composed of parts:
1. **Pipeline**: 
    **A.** dbt modeling data: ![model graph](/user_panel_graph.PNG)
    **B.** data loading  python script:  load user_panel table to indexed Postgresql table (deployed on GCP) for efficient fetching 
2. **Api-Service**: Web api Expose GetAttribute by player Id, using FastApi web framework and psycopg2 to interact with Postgresql







