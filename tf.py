#!/usr/bin/env python3

import requests
import os
import sys
import zipfile
import shutil
from tqdm import tqdm
from urllib.parse import urlparse

# --- Platform-specific configuration ---
if sys.platform == "darwin":
    # macOS
    font_dir = os.path.expanduser("~/Library/Fonts")
    refresh_cmd = "atsutil server -shutdown && atsutil server -ping"
    user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36'
else:
    # Linux (and other POSIX)
    font_dir = os.path.expanduser("~/.local/share/fonts")
    refresh_cmd = "fc-cache -f"
    user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36'
# ---

if len(sys.argv) < 2:
    print("Usage: tf <font-url>")
    sys.exit(1)

url = sys.argv[1]

parsed_url = urlparse(url)
domain = parsed_url.netloc

font_slug = ""
download_url = ""

if 'dafont.com' in domain:
    font_slug = url.rstrip('/').split('/')[-1].replace('.font', '')
    download_slug = font_slug.replace('-', '_')
    download_url = f"https://dl.dafont.com/dl/?f={download_slug}"
elif '1001fonts.com' in domain:
    font_slug = url.rstrip('/').split('/')[-1].replace('-font.html', '')
    download_url = f"https://www.1001fonts.com/download/{font_slug}.zip"
else:
    print(f"❌ Unsupported font website: {domain}")
    sys.exit(1)


print(f"📦 Downloading {font_slug} from {download_url}")

headers = {
    'User-Agent': user_agent
}

try:
    response = requests.get(download_url, stream=True, headers=headers)
    response.raise_for_status()
except Exception as e:
    print(f"❌ Failed to download the font zip: {e}")
    sys.exit(1)

zip_path = f"{font_slug}.zip"
total = int(response.headers.get('content-length', 0))

with open(zip_path, "wb") as file, tqdm(
    desc=zip_path,
    total=total,
    unit='B',
    unit_scale=True,
    unit_divisor=1024,
) as bar:
    for data in response.iter_content(chunk_size=1024):
        size = file.write(data)
        bar.update(size)

print("📂 Extracting fonts...")

temp_dir = "./.tf-temp"
try:
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(temp_dir)
except zipfile.BadZipFile:
    print("❌ File is not a valid zip file.")
    os.remove(zip_path)
    sys.exit(1)

os.remove(zip_path)

font_files = [f for f in os.listdir(temp_dir) if f.lower().endswith((".ttf", ".otf"))]

if not font_files:
    print("❌ No font files found in the zip.")
    shutil.rmtree(temp_dir)
    sys.exit(1)

os.makedirs(font_dir, exist_ok=True)

for font_file in font_files:
    src = os.path.join(temp_dir, font_file)
    dst = os.path.join(font_dir, font_file)
    shutil.move(src, dst)

shutil.rmtree(temp_dir)

print("🔄 Refreshing font cache...")
os.system(refresh_cmd)

print(f"✅ Installed '{font_slug}' font!")
