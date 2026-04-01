import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
import pandas as pd


# Load environment variables
load_dotenv()

# Read DB path from environment variable
DB_PATH = os.getenv('DB_PATH', './data/database.db')  # fallback to default
DB_URL = f'sqlite:///{DB_PATH}'

# Connect to the existing SQLite database
def connect():
    try:
        engine = create_engine(DB_URL)
        engine.connect()
        print("✅ Connected to existing SQLite database.")
        return engine
    except Exception as e:
        print(f"❌ Error connecting to database: {e}")
        return None

# Run student-defined queries from queries.sql
def run_queries_from_file(engine, filepath):
    try:
        # FIX 1 — UTF-8 Encoding:
        # The original open() call did not specify an encoding, so Python used
        # the system default (cp1252 on Windows). This caused the error:
        # 'charmap' codec can't decode byte 0x8f
        # because queries.sql contains UTF-8 characters (accents, emojis).
        # Fix: explicitly specify encoding='utf-8'.
        with open(filepath, 'r', encoding='utf-8') as file:
            content = file.read()
        queries = [q.strip() for q in content.split(';') if q.strip()]
        for i, query in enumerate(queries, start=0):
            # Skip if it's just a comment
            if query.startswith('--') or not any(c.isalnum() for c in query):
                continue
            try:
                print(f"\n🔎 Query {i}:\n{query}")
                # FIX 2 — DML statement support (INSERT, UPDATE, DELETE):
                # pd.read_sql() only works with SELECT, as it expects rows in return.
                # For INSERT/UPDATE/DELETE it raised the error:
                # "This result object does not return rows. It has been closed automatically."
                # Fix: detect the statement type and use engine.begin() + sqlalchemy.text()
                # for DML operations, which opens a transaction and auto-commits on exit.
                # pd.read_sql() is kept for SELECT statements.
                first_word = query.strip().split()[0].upper()
                if first_word in ('INSERT', 'UPDATE', 'DELETE'):
                    with engine.begin() as conn:
                        from sqlalchemy import text
                        conn.execute(text(query))
                    print("✅ Executed successfully.")
                else:
                    df = pd.read_sql(query, con=engine)
                    print(df)
            except Exception as e:
                print(f"❌ Error in Query {i}: {e}")
    except Exception as e:
        print(f"❌ Error processing queries from {filepath}: {e}")


# Entry point
if __name__ == "__main__":
    engine = connect()
    if engine:
        run_queries_from_file(engine, './src/sql/queries.sql')