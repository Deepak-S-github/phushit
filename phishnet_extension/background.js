chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    if (changeInfo.status === "complete" && tab.url.startsWith("http")) {
      console.log("🔍 Page loaded:", tab.url);
  
      // You can scan the URL using your Flask backend
      fetch("http://192.168.183.17/predict", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ url: tab.url })
      })
      .then(response => response.json())
      .then(data => {
        console.log(`✅ Scan complete for ${tab.url}: ${data.result}`);
  
        // Send result to content script if needed
        chrome.tabs.sendMessage(tabId, {
          action: "phishing_result",
          result: data.result,
          url: tab.url
        });
      })
      .catch(err => {
        console.error("❌ Error calling Flask backend:", err);
      });
    }
  });
  
