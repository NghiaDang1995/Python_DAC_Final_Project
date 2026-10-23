import os  #làm việc với hệ điều hành
from io import BytesIO #làm việc với ram k làm việc trên ổ cứng
import pandas as pd
from google.oauth2 import service_account #xác nhân với service account
from googleapiclient.discovery import build #tương tác với api của google drive
from googleapiclient.http import MediaIoBaseDownload #tải file từ google drive về ram
from sqlalchemy import create_engine #kết nối với cơ sở dữ liệu
from dotenv import load_dotenv #làm việc với file .env
import uuid

load_dotenv(r"C:\Users\DELL\Desktop\Python Final Project\.env") #load file .env

GOOGLE_SERVICE_ACCOUNT_PATH = os.getenv("GOOGLE_SERVICE_ACCOUNT")
GOOGLE_DRIVE_FOLDER = os.getenv("GOOGLE_DRIVE_FOLDER_ID")

SCOPE = ['https://www.googleapis.com/auth/drive.readonly'] #quyền truy cập vào google drive
def get_service_account():
    credentials = service_account.Credentials.from_service_account_file(
        GOOGLE_SERVICE_ACCOUNT_PATH, scopes=SCOPE
    
    )
    service = build('drive',
                     'v3',
                       credentials = credentials)
    return service
def download_data(service, file_id):
    request = service.files().get_media(
        fileId=file_id,
        supportsAllDrives= True
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
        df = pd.read_csv(buffer, encoding='utf-8-sig')
    elif filename.endswith('.xlsx'):
        df = pd.read_excel(buffer,
                             engine = 'openpyxl')
    return df
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
service = get_service_account()
buffer = download_data(service, file_id = '1FgbhmebOW1S9i7l6KkgWla8w0jHk7UaC')
data = read_data('Territory_Mapping.xlsx', buffer)
print(data.head())

# 1. Gắn thời gian tải dữ liệu
data['ingestion_at'] = pd.Timestamp.now()

# 2. Gắn tên file nguồn
data["_source_file"] = "Territory_Mapping.xlsx"

# 3. Gắn nguồn lưu trữ
data["_source_platform"] = "google_drive"

# 4. Tạo mã Batch ID duy nhất cho lần chạy này
data["_batch_id"] = str(uuid.uuid4())

engine = create_connection_postgres()

# Đẩy dữ liệu vào schema 'raw', bảng 'Territor_Mapping'
data.to_sql(
    name="SCR08_Territory_Mapping",
    con= engine,
    schema="bronze",  # Lưu vào schema raw (Bronze layer)
    if_exists="append",  # Nếu bảng đã có thì ghi tiếp vào dưới
)