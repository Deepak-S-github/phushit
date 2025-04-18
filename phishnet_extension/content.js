// Listen for messages from background.js
chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
    if (msg.action === "phishing_result" && msg.result === "Phishing") {
      console.log("🚨 Phishing site detected! Injecting warning banner...");
  
      // Check if banner already exists
      if (document.getElementById("phishnet-warning-banner")) return;
  
      // Create the warning banner
      const banner = document.createElement("div");
      banner.id = "phishnet-warning-banner";
      banner.textContent = "⚠️ WARNING: This website has been flagged as a potential phishing site by PhishNet!";
      banner.style.position = "fixed";
      banner.style.top = "0";
      banner.style.left = "0";
      banner.style.width = "100%";
      banner.style.padding = "15px";
      banner.style.zIndex = "9999";
      banner.style.backgroundColor = "#d32f2f";
      banner.style.color = "#fff";
      banner.style.fontWeight = "bold";
      banner.style.textAlign = "center";
      banner.style.fontSize = "16px";
      banner.style.boxShadow = "0 2px 6px rgba(0,0,0,0.3)";
  
      document.body.prepend(banner);
    }
  });
  