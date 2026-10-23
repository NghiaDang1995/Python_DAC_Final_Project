import os  # làm việc với hệ điều hành
from io import BytesIO  # làm việc với ram k làm việc trên ổ cứng
import pandas as pd
from google.oauth2 import service_account  # xác nhân với service account
from googleapiclient.discovery import build  # tương tác với api của google drive
from googleapiclient.http import MediaIoBaseDownload  # tải file từ google drive về ram
from sqlalchemy import create_engine  # kết nối với cơ sở dữ liệu
from dotenv import load_dotenv  # làm việc với file .env
import uuid

load_dotenv(r"C:\Users\DELL\Desktop\Python Final Project\.env")  # load file .env

GOOGLE_SERVICE_ACCOUNT_PATH = os.getenv("GOOGLE_SERVICE_ACCOUNT")
GOOGLE_DRIVE_FOLDER = os.getenv("GOOGLE_DRIVE_FOLDER_ID")

SCOPE = ['https://www.googleapis.com/auth/drive.readonly']  # quyền truy cập vào google drive

def get_service_account():
    credentials = service_account.Credentials.from_service_account_file(
        GOOGLE_SERVICE_ACCOUNT_PATH, scopes=SCOPE
    )
    service = build('drive', 'v3', credentials=credentials)
    return service

def download_data(service, file_id):
    request = service.files().get_media(
        fileId=file_id,
        supportsAllDrives=True
    )
    buffer = BytesIO()
    downloader = MediaIoBaseDownload(buffer, request)
    done = False
    while not done:
        status, done = downloader.next_chunk()
    buffer.seek(0)
    return buffer

def read_data(filename, buffer):
    if filename.endswith('.csv'):
        return {'default': pd.read_csv(buffer)}
    elif filename.endswith('.xlsx'):
        # sheet_name=None trả về dict dạng {tên_sheet: DataFrame}
        return pd.read_excel(buffer, sheet_name=None, engine='openpyxl')
    return {}

def create_connection_postgres():
    PG_USER = os.getenv("DB_USER")
    PG_PASSWORD = os.getenv("DB_PASSWORD")
    PG_HOST = os.getenv("DB_HOST")
    PG_PORT = os.getenv("DB_PORT")
    PG_DATABASE = os.getenv("DB_NAME")

    engine = create_engine(
        f"postgresql://{PG_USER}:{PG_PASSWORD}@{PG_HOST}:{PG_PORT}/{PG_DATABASE}"
    )
    return engine

# --- MAIN EXECUTION ---
service = get_service_account()
buffer = download_data(service, file_id='1-BLii_-P0NQ4jlcG9ckbyfkZk54vo19s')

data = read_data('Sales_Target_Plan.xlsx', buffer)

batch_id = str(uuid.uuid4())
ingestion_time = pd.Timestamp.now()
engine = create_connection_postgres()

# Duyệt qua từng sheet (version)
for sheet_name, df in data.items():
    #  Bỏ qua sheet Summary hoặc các sheet không liên quan đến target
    if sheet_name.lower().strip() in ['summary', 'tổng quan', 'readme']:
        print(f"\n--- Bỏ qua sheet metadata/tổng hợp: {sheet_name} ---")
        continue

    print(f"\n--- Đang xử lý sheet target: {sheet_name} ---")
    print(df.head())

    # 1. Gắn thời gian tải dữ liệu
    df['ingestion_at'] = ingestion_time

    # 2. Gắn tên file nguồn
    df["_source_file"] = "Sales_Target_Plan.xlsx"

    # 3. Gắn nguồn lưu trữ
    df["_source_platform"] = "google_drive"

    # 4. Tạo mã Batch ID duy nhất cho lần chạy này
    df["_batch_id"] = batch_id
    
    # 5. Lưu thêm cột version_label để phân biệt các sheet (Plan_v1_Original, Plan_v2_Adjustment_H2...)
    df["version_label"] = sheet_name

    # Ép kiểu toàn bộ về string/text để tuân thủ chuẩn Bronze Layer
    df = df.astype(str)

    # Đẩy dữ liệu target vào schema 'bronze', bảng 'SCR02_sales_target_plan'
    df.to_sql(
        name="SCR02_sales_target_plan",
        con=engine,
        schema="bronze",
        if_exists="append",
        index=False
    )

print("\nĐã load thành công toàn bộ các sheet Target vào bảng bronze.SCR02_sales_target_plan!")