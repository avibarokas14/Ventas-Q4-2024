// Función Email Alerta Automatico

function checkAmountAndSendEmail() {
  
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("TipoCambioDiario"); 
  
  const data = sheet.getDataRange().getValues();
  
  let previousAmount = 0;
  let previousDate = "";
  
  // Loop through the data to find the necessary amount and date
  for (let i = 1; i < data.length; i++) {
    const currentDate = data[i][0];  
    const currentAmount = data[i][1];  
    
    // Calculate the percentage change from the previous value
    if (previousAmount > 0) {
      const percentageChange = ((currentAmount - previousAmount) / previousAmount) * 100;
      
      // Check if the percentage change is 1% or more
      if (percentageChange >= 1) {
        const formattedDate = Utilities.formatDate(new Date(currentDate), Session.getScriptTimeZone(), "dd/MM/yyyy");
        const subject = "Exchange Rate Alert: Increase Detected";
        const body = `Date: ${formattedDate}\n\nExchange rate increased by: ${percentageChange.toFixed(2)}%\n\nPrevious amount: ${previousAmount.toFixed(2)}\n\nCurrent amount: ${currentAmount.toFixed(2)}\n\n\n\n*Update your prices may prevent potential revenue loss. `;
        sendEmail(subject, body);
        
        // Update the previous date and amount only after sending an email
        previousAmount = currentAmount;
        previousDate = currentDate;
      }
    }
    
    // If it's the first entry or no significant change, maintain the previous values
    if (previousAmount === 0) {
      previousAmount = currentAmount;
      previousDate = currentDate;
    }
  }
}

function sendEmail(subject, body) {
  const recipient = "YOUR_EMAIL_HERE"; 
  MailApp.sendEmail(recipient, subject, body);
}


// Función Trigger Diario

function createTrigger() {
  // Crear nuevo Trigger diariamente a las 7 AM
  ScriptApp.newTrigger('checkAmountAndSendEmail')
    .timeBased()
    .everyDays(1)  
    .atHour(7)      
    .create();
}
