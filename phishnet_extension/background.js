chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === "complete" && tab.url.startsWith("http")) {
    fetch("http://localhost:5000/predict", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ url: tab.url })
    })
      .then(res => res.json())
      .then(data => {
        if (data.prediction === "phishing") {
          chrome.scripting.executeScript({
            target: { tabId: tabId },
            files: ["content.js"]
          });
        }
      });
  }
});
