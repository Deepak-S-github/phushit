import joblib
import json

scaler = joblib.load('scaler.pkl')

scaler_data = {
    "mean": scaler.mean_.tolist(),
    "scale": scaler.scale_.tolist(),
    "features": scaler.feature_names_in_.tolist()
}

with open("scaler.json", "w") as f:
    json.dump(scaler_data, f)

print("✅ scaler.json saved")
