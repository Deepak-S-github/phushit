document.getElementById("scanBtn").addEventListener("click", () => {
  const url = document.getElementById("urlInput").value;
  fetch("http://localhost:5000/predict", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ url })
  })
    .then(res => res.json())
    .then(data => {
      document.getElementById("result").textContent = `⚠️ Result: ${data.prediction.toUpperCase()} (${data.confidence || "Score unknown"})`;
    });
});
