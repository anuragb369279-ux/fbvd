"""Standalone DB initializer - run from hvm/ directory."""
import sqlite3, os, sys
from datetime import datetime
from werkzeug.security import generate_password_hash
import secrets, hashlib

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, 'hvm.db')

# Load .env
env = {}
env_file = os.path.join(BASE_DIR, '.env')
if os.path.exists(env_file):
    with open(env_file) as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                k, v = line.split('=', 1)
                env[k.strip()] = v.strip().strip('"').strip("'")

ADMIN_USER = env.get('MAIN_ADMIN_USERNAME', 'admin')
ADMIN_EMAIL = env.get('MAIN_ADMIN_EMAIL', 'admin@example.com')
ADMIN_PASS = env.get('MAIN_ADMIN_PASSWORD', 'admin123')

conn = sqlite3.connect(DB_PATH)
conn.row_factory = sqlite3.Row
cur = conn.cursor()

# Check if settings table exists and has HVM values
cur.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='settings'")
if cur.fetchone():
    cur.execute("UPDATE settings SET value='PVM PANEL' WHERE key='site_name' AND value LIKE '%HVM%'")
    cur.execute("UPDATE settings SET value='Powered by PVM Panel' WHERE key='footer_text' AND value LIKE '%HVM%'")
    updated = cur.rowcount
    conn.commit()
    cur.execute("SELECT key, value FROM settings WHERE key IN ('site_name','footer_text')")
    for r in cur.fetchall():
        print(f"  {r[0]} = {r[1]}")
    print(f"Updated {updated} branding rows")
else:
    print("No settings table found - DB needs full init (restart the app)")

conn.close()
print("Done")
