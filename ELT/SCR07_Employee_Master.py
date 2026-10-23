import os  # làm việc với hệ điều hành
from io import BytesIO  # làm việc với RAM, không làm việc trên ổ cứng
import pandas as pd
from google.oauth2 import service_account  # xác nhận với service account
from googleapiclient.discovery import build  # tương tác với api của google drive
from googleapiclient.http import MediaIoBaseDownload  # tải file từ google drive về RAM
from sqlalchemy import create_engine  # kết nối với cơ sở dữ liệu
from sqlalchemy.types import TEXT, VARCHAR
from dotenv import load_dotenv  # làm việc với file .env
import uuid

# Load file .env (Sử dụng đường dẫn tương đối hoặc tuyệt đối tùy môi trường của bạn)
load_dotenv(r"C:\Users\DELL\Desktop\Python Final Project\.env") 

GOOGLE_SERVICE_ACCOUNT_PATH = os.getenv("GOOGLE_SERVICE_ACCOUNT")
GOOGLE_DRIVE_FOLDER = os.getenv("GOOGLE_DRIVE_FOLDER_ID")

SCOPE = ['https://www.googleapis.com/auth/drive.readonly'] # quyền truy cập vào google drive

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
        return {'default': pd.read_csv(buffer, dtype=str)}
    elif filename.endswith('.xlsx'):
        # sheet_name=None trả về dict dạng {tên_sheet: DataFrame}
        # dtype=str giúp ngăn chặn triệt để lỗi ép kiểu ngầm định giữa các sheet (v1, v2)
        return pd.read_excel(buffer, sheet_name=None, engine='openpyxl', dtype=str)
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

# --- BẮT ĐẦU PIPELINE ---
service = get_service_account()
file_id = '1w8m7d8Z7b0tE_xNLYv6KETypYf4un6Kj'
buffer = download_data(service, file_id)

# Đọc dữ liệu Excel thành dict các sheet
sheets_data = read_data('Employee_Master.xlsx', buffer)

# Khởi tạo thông tin kết nối và metadata chung cho toàn bộ batch chạy
engine = create_connection_postgres()
batch_id = str(uuid.uuid4())
ingestion_time = pd.Timestamp.now()
source_file = "Employee_Master.xlsx"

# Duyệt qua từng sheet trong file Excel
for sheet_name, df in sheets_data.items():
    # 1. Bỏ qua các sheet metadata, summary hoặc sheet bị rỗng
    if sheet_name.lower().strip() in ['summary', 'tổng quan', 'readme', 'change_log'] or df.empty:
        print(f"\n--- Bỏ qua sheet không thuộc target hoặc rỗng: {sheet_name} ---")
        continue

    print(f"\n--- Đang xử lý sheet target: {sheet_name} ---")

    # 2. Chuẩn hóa tên cột (về chữ thường, xóa khoảng trắng thừa)
    df.columns = df.columns.str.strip().str.lower()

    # 3. Gắn các trường metadata chuẩn hóa cho tầng Bronze
    df['ingestion_at'] = ingestion_time
    df["_source_file"] = source_file
    df["_source_platform"] = "google_drive"
    df["_batch_id"] = batch_id

    # 4. Đẩy dữ liệu vào PostgreSQL (schema 'bronze')
    df.to_sql(
        name="SCR07_Employee_Master",
        con=engine,
        schema="bronze",      # Lưu vào schema bronze (Bronze layer)
        if_exists="append",   # Ghi tiếp dữ liệu vào bảng
        index=False,          # Không đẩy cột index của Pandas xuống database
        dtype={
            'transfer_note': TEXT(),
            'phone': VARCHAR(50),
            'employee_id': VARCHAR(50)
        }
    )
    print(f"-> Đã nạp thành công sheet '{sheet_name}' vào bronze.SCR07_Employee_Master")