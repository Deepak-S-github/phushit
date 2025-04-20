from flask import Flask, request, jsonify
from urllib.parse import urlparse
import pandas as pd
import numpy as np
import joblib
import os
import re

# Load model and scaler
model = joblib.load('model/phishing_model.pkl')
scaler = joblib.load('model/scaler.pkl')

app = Flask(__name__)

# Full feature list
FEATURE_COLUMNS = [
    'url_length', 'n_slash', 'n_questionmark', 'n_equal', 'n_at', 'n_and',
    'n_exclamation', 'n_asterisk', 'n_hastag', 'n_percent',
    'dots_per_length', 'hyphens_per_length', 'is_long_url', 'has_many_dots',
    'has_ssl', 'is_cloudflare_protected', 'special_char_density',
    'suspicious_tld_risk', 'has_redirects', 'risk_score', 'url_complexity'
]

suspicious_tlds = ['zip', 'review', 'country', 'stream', 'biz', 'top', 'tk', 'ml', 'ga', 'cf']

# Extract only the base domain for analysis
def extract_base_domain(url):
    parsed = urlparse(url)
    domain = f"{parsed.scheme}://{parsed.netloc}"
    print(f"🔗 Extracted base domain: {domain}")
    return domain

def extract_url_features(url):
    parsed = urlparse(url)
    hostname = parsed.hostname or ""
    path = parsed.path or ""

    url_length = len(url)
    n_slash = url.count('/')
    n_questionmark = url.count('?')
    n_equal = url.count('=')
    n_at = url.count('@')
    n_and = url.count('&')
    n_exclamation = url.count('!')
    n_asterisk = url.count('*')
    n_hastag = url.count('#')
    n_percent = url.count('%')

    dot_count = url.count('.')
    hyphen_count = url.count('-')

    dots_per_length = dot_count / url_length if url_length else 0
    hyphens_per_length = hyphen_count / url_length if url_length else 0

    is_long_url = int(url_length > 75)
    has_many_dots = int(dot_count > 5)
    has_ssl = int(parsed.scheme == 'https')
    is_cloudflare_protected = int('cloudflare' in hostname)

    special_chars = n_questionmark + n_equal + n_at + n_and + n_exclamation + n_asterisk + n_hastag + n_percent
    special_char_density = special_chars / url_length if url_length else 0

    tld = hostname.split('.')[-1]
    suspicious_tld_risk = int(tld in suspicious_tlds)
    has_redirects = int('//' in url[url.find('//') + 2:])

    risk_score = (is_long_url + has_many_dots + suspicious_tld_risk + special_char_density + n_at) / 5
    url_complexity = len(re.findall(r'[A-Za-z0-9]', url)) / url_length if url_length else 0

    features = {
        'url_length': url_length,
        'n_slash': n_slash,
        'n_questionmark': n_questionmark,
        'n_equal': n_equal,
        'n_at': n_at,
        'n_and': n_and,
        'n_exclamation': n_exclamation,
        'n_asterisk': n_asterisk,
        'n_hastag': n_hastag,
        'n_percent': n_percent,
        'dots_per_length': dots_per_length,
        'hyphens_per_length': hyphens_per_length,
        'is_long_url': is_long_url,
        'has_many_dots': has_many_dots,
        'has_ssl': has_ssl,
        'is_cloudflare_protected': is_cloudflare_protected,
        'special_char_density': special_char_density,
        'suspicious_tld_risk': suspicious_tld_risk,
        'has_redirects': has_redirects,
        'risk_score': risk_score,
        'url_complexity': url_complexity,
    }

    print(f"🔍 Extracted features from domain: {features}")
    return pd.DataFrame([features])[FEATURE_COLUMNS], features

@app.route("/", methods=["GET"])
def root():
    return "🟢 PhishNet Flask API is running with full features!"

@app.route("/predict", methods=["POST"])
def predict():
    try:
        data = request.get_json()
        url = data.get("url")

        if not url:
            print("⚠️ No URL provided in request.")
            return jsonify({"error": "No URL provided"}), 400

        print(f"📥 Received URL: {url}")
        base_domain = extract_base_domain(url)
        feature_df, raw_features = extract_url_features(base_domain)

        scaled_features = scaler.transform(feature_df)
        prediction = model.predict(scaled_features)[0]
        confidence = model.predict_proba(scaled_features)[0][1]

        result = "Phishing" if prediction == 1 else "Safe"

        print(f"✅ Prediction: {result} | Confidence: {confidence * 100:.2f}%")

        return jsonify({
            "url": url,
            "base_domain": base_domain,
            "result": result,
            "confidence": f"{confidence * 100:.2f}%",
            "features": raw_features
        })

    except Exception as e:
        print(f"❌ Error: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    print("🚀 Flask app running with advanced phishing detection!")
    app.run(debug=True, host='0.0.0.0', port=5000)
