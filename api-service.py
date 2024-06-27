import os
import time
import uvicorn
import psycopg2
from fastapi import FastAPI, HTTPException

from psycopg2 import sql
from psycopg2.pool import ThreadedConnectionPool
from dotenv import load_dotenv

load_dotenv()
app = FastAPI()
port_api = os.getenv("API_PORT")

# Database connection details
postgres_conn = os.getenv("POSTGRES_CONN")

# Initialize the connection pool
connection_pool = ThreadedConnectionPool(
    minconn=1,
    maxconn=100,
    dsn=postgres_conn
)

def get_db_connection():
    return connection_pool.getconn()

@app.get("/get-player-attribute")
def get_attribute(player_id: str, attribute: str):
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Fetch the player attribute
        if attribute and player_id:
            query = sql.SQL("SELECT {attr} FROM user_panel WHERE player_id = %s").format(attr=sql.Identifier(attribute))
        tic = time.time()
        cursor.execute(query, (player_id,))
        toc = time.time()
        print("execute time:", toc - tic)
        result = cursor.fetchone()
        if not result:
            raise HTTPException(status_code=404, detail="Player not found")
        if attribute:
            return {attribute: result[0]}
        else:
            return dict(zip([desc[0] for desc in cursor.description], result))
    
    except Exception as e:
        print(e)
        raise HTTPException(status_code=500, detail=str(e))
    
    finally:
        # Close the cursor and return the connection to the pool
        if cursor:
            cursor.close()
        if conn:
            connection_pool.putconn(conn)

# Run the server
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=int(port_api))
