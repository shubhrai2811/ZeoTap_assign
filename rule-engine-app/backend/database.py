import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

# These variables should be in GitHub secrets but are shared here so that it can be run locally
SUPABASE_URL = "https://llwcfqjlpvuhnfepbimp.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imxsd2NmcWpscHZ1aG5mZXBiaW1wIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjkzNDE2MTMsImV4cCI6MjA0NDkxNzYxM30.V5-wpiM5SGyRgbwItpnMCqii9B-vRKLXsq9IxO3mMPg"

print(f"SUPABASE_URL: {SUPABASE_URL}")
print(f"SUPABASE_KEY: {SUPABASE_KEY}")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
