document.getElementById("scanBtn").addEventListener("click", async () => {
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    const url = tab.url;
  
    document.getElementById("result").textContent = "Scanning...";
  
    const response = await fetch("http://192.168.183.17/predict", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ url: url })
    });
  
    const data = await response.json();
    document.getElementById("result").textContent = `Result: ${data.result}`;
  });
  
