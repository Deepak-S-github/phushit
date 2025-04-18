from flask import Flask, request, jsonify
import joblib
import os

# Load the trained model
model_path = os.path.join("model", "phishing_model.pkl")
print(f"🔍 Loading model from: {model_path}")
model = joblib.load(model_path)
print("✅ Model loaded successfully!")

app = Flask(__name__)

# Feature extraction from URL
def extract_features(url):
    features = [
        len(url),
        int("@" in url),
        int("-" in url),
        int(url.startswith("https")),
        url.count('.')
    ]
    print(f"🔍 Extracted features from URL: {features}")
    return features

# Health check endpoint
@app.route("/", methods=["GET"])
def root():
    return "🟢 PhishNet Flask API is running!"

# Prediction API
@app.route("/predict", methods=["POST"])  # ✅ Fixed: removed "\n"
def predict():
    print("📥 Received request on /predict")
    try:
        data = request.get_json()
        print(f"🧾 Raw data: {data}")

        url = data.get("url")
        if not url:
            print("⚠️ No URL provided in request.")
            return jsonify({"error": "No URL provided"}), 400

        features = extract_features(url)
        prediction = model.predict([features])[0]
        result = "Phishing" if prediction == 1 else "Safe"

        print(f"✅ Prediction for '{url}': {result}")
        return jsonify({
            "url": url,
            "result": result,
            "features": {
                "url_length": features[0],
                "has_at": features[1],
                "has_dash": features[2],
                "uses_https": features[3],
                "num_dots": features[4]
            }
        })

    except Exception as e:
        print("❌ Error during prediction:", str(e))
        return jsonify({"error": "Something went wrong", "details": str(e)}), 500

if __name__ == "__main__":
    print("🚀 Starting Flask server...")
    app.run(debug=True, host='0.0.0.0', port=5000)  # ✅ Makes it reachable by your phone over Wi-Fi
