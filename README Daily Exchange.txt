// Función Importar el Tipo de Cambio de Ayer desde API

function importYesterdayExchangeRate() {
  var apiKey = 'YOUR_API_KEY_HERE'; 
  var baseCurrency = 'USD'; 
  var targetCurrency = 'ARS'; 

  //  Fecha YYYY-MM-DD format
  var date = new Date();
  date.setDate(date.getDate() - 1); // Set the date to yesterday
  var formattedDate = Utilities.formatDate(date, Session.getScriptTimeZone(), 'yyyy-MM-dd');
  
  // API URL para obtener el tipo de cambio de ayer
  var url = 'https://openexchangerates.org/api/historical/' + formattedDate + '.json?base=' + baseCurrency + '&symbols=' + targetCurrency + '&app_id=' + apiKey;
  
  try {
    // Obtener datos de la API
    var response = UrlFetchApp.fetch(url);
    var json = JSON.parse(response.getContentText());
    
    // Extraer el tipo de cambio
    var exchangeRate = json.rates[targetCurrency];
    
    // Abrir o crear la hoja
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('TipoCambioDiario');
    
    if (!sheet) {
      sheet = SpreadsheetApp.getActiveSpreadsheet().insertSheet('TipoCambioDiario');
      sheet.appendRow(['Fecha', 'Tipo de Cambio']);
    }
    
    // Adjuntar los datos a la hoja
    sheet.appendRow([formattedDate, exchangeRate]);
  } catch (error) {
    Logger.log('Error fetching data: ' + error.message);
  }
}


// Función Trigger Diario

function createDailyTrigger() {
  // Eliminar Trigger Activos para Evidar Duplicados
  var triggers = ScriptApp.getProjectTriggers();
  for (var i = 0; i < triggers.length; i++) {
    if (triggers[i].getHandlerFunction() === 'importYesterdayExchangeRate') {
      ScriptApp.deleteTrigger(triggers[i]);
    }
  }
  
  // Crear nuevo Trigger diariamente a las 6 AM
  ScriptApp.newTrigger('importYesterdayExchangeRate')
    .timeBased()
    .atHour(6)
    .everyDays(1)
    .create();
}
