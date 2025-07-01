// Función Importar Datos Históricos desde API

function importLastQuarterExchangeRates() {
  var apiKey = 'YOUR_API_KEY_HERE'; 
  var baseCurrency = 'USD'; 
  var targetCurrency = 'ARS'; 
  
  // Rango para el último trimestre
  var startDate = new Date('2024-10-01');
  var endDate = new Date('2024-12-31');
  
  // Importar a Google Sheets
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('TipoCambioDiario');
  if (!sheet) {
    sheet = SpreadsheetApp.getActiveSpreadsheet().insertSheet('TipoCambioDiario');
    sheet.appendRow(['Fecha', 'Tipo de Cambio']);
  }

  // Recorrer cada fecha en el rango
  var currentDate = startDate;
  while (currentDate <= endDate) {
    var formattedDate = Utilities.formatDate(currentDate, Session.getScriptTimeZone(), 'yyyy-MM-dd');
    var url = 'https://openexchangerates.org/api/historical/' + formattedDate + '.json?base=' + baseCurrency + '&symbols=' + targetCurrency + '&app_id=' + apiKey;
    
    try {
      // Obtener datos de la API
      var response = UrlFetchApp.fetch(url);
      var json = JSON.parse(response.getContentText());
      
      // Extraer el tipo de cambio
      var exchangeRate = json.rates[targetCurrency];
      
      // Adjuntar los datos a la hoja.
      sheet.appendRow([formattedDate, exchangeRate]);
    } catch (error) {
      Logger.log('Error fetching data for ' + formattedDate + ': ' + error.message);
    }
    
    // Pasar al día siguiente
    currentDate.setDate(currentDate.getDate() + 1);
  }
}


