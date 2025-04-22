const banner = document.createElement("div");
banner.textContent = "⚠️ Warning: This site is flagged as a potential phishing site by PhishNet.";
banner.style.cssText = `
  position: fixed;
  top: 0;
  width: 100%;
  background: red;
  color: white;
  text-align: center;
  font-size: 16px;
  padding: 10px;
  z-index: 9999;
`;
document.body.prepend(banner);
