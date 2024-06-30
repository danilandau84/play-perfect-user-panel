import os
import psycopg2
import datetime
from google.cloud import bigquery
from google.oauth2 import service_account 

from sqlalchemy import create_engine
from dotenv import load_dotenv


load_dotenv()
# Function to connect to BigQuery and fetch data
def fetch_data_from_bigquery(project_id, dataset_id, table_id):

    service_acount_file =os.getenv("SERVICE_ACCOUNT_FILE")
    # os.getenv('SERVICE_ACCOUNT_FILE', default='play-perfect-key.json')
    credentials = service_account.Credentials.from_service_account_file(service_acount_file,
                                                                           scopes=["https://www.googleapis.com/auth/cloud-platform"]);
    client = bigquery.Client(credentials=credentials, project=credentials.project_id)
 
    # Construct a reference to the BigQuery table
    table_ref = client.dataset(dataset_id).table(table_id)
    table = client.get_table(table_ref)

    # Fetch data into a DataFrame
    query = f"SELECT * FROM `{project_id}.{dataset_id}.{table_id}`"
    print(query)
    df = client.query(query).to_dataframe()
    return df

# Function to connect to PostgreSQL and insert data
def insert_data_to_postgresql(df, connection_string, table_name):
    
    engine = create_engine(connection_string)
    df.to_sql( name=table_name, con=engine, if_exists="append",  index=False)

def reset_target_table(connection_string):
    conn = psycopg2.connect(connection_string)
    cursor = conn.cursor()
    reset_table_script ="""
                            DROP TABLE IF EXISTS  public.user_panel ;
                            CREATE TABLE user_panel (
                                player_id VARCHAR PRIMARY KEY,
                                country VARCHAR,
                                avg_price_10 FLOAT,
                                last_weighted_daily_matches_count_10_played_days FLOAT,
                                active_days_since_last_purchase INTEGER,
                                score_perc_50_last_5_days FLOAT
                            );
                            """

    cursor.execute(reset_table_script)
    conn.commit()

    



def main():
    # BigQuery credentials and table information
    project_id = 'play-perfect-427411'
    dataset_id = 'PLAYPERFECT'
    table_id = 'user_panel_table'

    postgres_table_name = 'user_panel'
    postgres_conn = os.getenv("POSTGRES_CONN")

    print(datetime.datetime.now(),"Fetching data from bigquery...")
    df = fetch_data_from_bigquery(project_id, dataset_id, table_id)
    print(datetime.datetime.now(),"Rebuild indexed relational table...")
    reset_target_table(postgres_conn)
    print(datetime.datetime.now(),"Inserting data into table...")
    insert_data_to_postgresql(df,postgres_conn, postgres_table_name)

if __name__ == "__main__":
    main()
    print(datetime.datetime.now(),"LOAD FINISH ")
