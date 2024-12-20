import pandas as pd
from google.cloud.sql.connector import Connector, IPTypes
from sqlalchemy import create_engine

from settings import get_settings
from services.secret_manager import get_secret_manager


class DataService:
    def __init__(self):
        self.settings = get_settings()


    def get_data(self, resource_name: str):
        # Load the CSV data into a DataFrame using gcsfs
        df = pd.read_csv(f"gs://{self.settings.DATA_BUCKET_NAME}/data/{resource_name}.csv")

        # Initialize the Cloud SQL Connector
        connector = Connector()

        # Create a connection function using the connector
        def getconn():
            conn = connector.connect(
                self.settings.DB_CONNECTION_NAME,
                "pymysql",
                user=self.settings.DB_USER,
                password=get_secret_manager().get_secret(self.settings.DB_PASSWORD_SECRET_ID),
                db=self.settings.DB_NAME,
                ip_type=IPTypes.PRIVATE
            )
            return conn

        # Create a SQLAlchemy engine using the connection function
        engine = create_engine(
            "mysql+pymysql://",
            creator=getconn
        )
        # Write the DataFrame to the SQL database
        df.to_sql(name=resource_name, con=engine, if_exists='replace', index=False)

        # Read the data back from the SQL database
        query = f"SELECT * FROM {resource_name}"
        sql_df = pd.read_sql(query, engine)

        data = sql_df.to_dict(orient='records')
        engine.dispose()

        # Close the connector
        connector.close()
        return data
