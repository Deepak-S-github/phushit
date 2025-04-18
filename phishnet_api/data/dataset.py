import requests
import pandas as pd
import random
import string
from io import StringIO

# Function to generate synthetic URLs
def generate_url(phishing=True):
    domain = ''.join(random.choices(string.ascii_lowercase, k=random.randint(5, 15)))
    tld = random.choice(['.com', '.net', '.org', '.in'])
    prefix = 'http' + random.choice(['', 's']) + '://'
    extra = ''

    if phishing:
        if random.random() < 0.5:
            domain += '-' + ''.join(random.choices('1234567890', k=2))
        if random.random() < 0.4:
            domain += '@malicious'
        if random.random() < 0.5:
            extra = '/' + ''.join(random.choices('xyz0123456789', k=10))
    else:
        if random.random() < 0.3:
            domain = 'www.' + domain

    return prefix + domain + tld + extra

# Generate 9000 synthetic URLs
synthetic_data = []
for _ in range(9000):
    label = random.choice([0, 1])
    url = generate_url(phishing=bool(label))
    synthetic_data.append({
        'url': url,
        'url_length': len(url),
        'has_at': int('@' in url),
        'has_dash': int('-' in url),
        'uses_https': int(url.startswith('https')),
        'num_dots': url.count('.'),
        'label': label
    })

# Try to fetch real phishing URLs from PhishTank
real_data = []
try:
    response = requests.get("https://data.phishtank.com/data/online-valid.csv")
    if response.status_code == 200:
        csv_data = StringIO(response.text)
        phish_df = pd.read_csv(csv_data)
        urls = phish_df['url'].dropna().head(1000)  # Limit to 1000 real phishing URLs
        for url in urls:
            real_data.append({
                'url': url,
                'url_length': len(url),
                'has_at': int('@' in url),
                'has_dash': int('-' in url),
                'uses_https': int(url.startswith('https')),
                'num_dots': url.count('.'),
                'label': 1
            })
except Exception as e:
    print("Could not fetch real data:", e)

# Combine both
final_data = synthetic_data + real_data
df = pd.DataFrame(final_data)

# Save to CSV
df.to_csv("final_phishing_dataset.csv", index=False)
print("✅ Final dataset saved as 'final_phishing_dataset.csv'")
