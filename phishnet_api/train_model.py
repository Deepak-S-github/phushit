import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report
import joblib
import os

# Load your final dataset
df = pd.read_csv("data/final_phishing_dataset.csv")

# Feature columns
features = ['url_length', 'has_at', 'has_dash', 'uses_https', 'num_dots']
X = df[features]
y = df['label']

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train the model
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# Evaluate the model
y_pred = model.predict(X_test)
print(f"✅ Accuracy: {accuracy_score(y_test, y_pred):.2f}")
print("\n📊 Classification Report:\n", classification_report(y_test, y_pred))

# Save the model to model/
os.makedirs("model", exist_ok=True)
joblib.dump(model, "model/phishing_model.pkl")
print("✅ Model saved as 'model/phishing_model.pkl'")
