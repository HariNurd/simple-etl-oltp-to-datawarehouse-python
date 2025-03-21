import pandas as pd
import sqlalchemy as sa

from config import oltp_conn_string, warehouse_conn_string, oltp_tables, dimension_columns, ddl_statements, ddl_marts

def create_tables():
    """Buat table di dalam datawarehouse jika belum ada"""
    engine = sa.create_engine(warehouse_conn_string)
    with engine.connect() as conn:
        for ddl in ddl_statements.values():
            conn.execute(sa.text(ddl))
            conn.commit()

def extract_data(table_name):
    """Extract data dari table di database oltp"""
    engine = sa.create_engine(oltp_conn_string)
    query = f"SELECT * FROM {table_name}"
    df = pd.read_sql(query, engine)
    print(f'Extract Data {table_name} Success')
    return df

def transform_data(df, target_table):
    """Transform the extracted data to match the schema of the target dimension table"""
    columns = dimension_columns.get(target_table)
    if columns:
        df = df[columns]
    print(f'Transform Data {target_table} Success')
    return df

def transform_fact_orders():
    """Transform data for the fact_orders table"""
    dataframes = {table: extract_data(table) for table in oltp_tables.values()}

    df_orders = dataframes['tb_orders']
    df_orders = df_orders.merge(dataframes['tb_user'], on = 'user_id')
    df_orders = df_orders.merge(dataframes['tb_payment'], on = 'payment_id')
    df_orders = df_orders.merge(dataframes['tb_shipper'], on = 'shipper_id')
    df_orders = df_orders.merge(dataframes['tb_rating'], on = 'rating_id')
    df_orders = df_orders.merge(dataframes['tb_voucher'], how='left', on = 'voucher_id')
    df_orders.rename(columns={'user_id_x' : 'user_id'}, inplace=True)

    fact_orders_columns = dimension_columns.get('fact_orders')
    return df_orders[fact_orders_columns]

def load_data(df, table_name):
    """Load the transformed data into the target table in the data warehouse"""
    engine = sa.create_engine(warehouse_conn_string)
    with engine.connect() as conn:
        # Masukan data baru
        df.to_sql(table_name, conn, index=False, if_exists='append', method='multi')
        print(f'Load Data {table_name} Success')