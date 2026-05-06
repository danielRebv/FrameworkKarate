Feature: Actualizar clave
  Background:
    * def token2token = read('classpath:features/steps/token.feature@token2token')
    * def encriptado = read('classpath:features/steps/aesRsa.feature@claveEncriptada')

  @peformance=update_auth @env=perf
  Scenario: Performance api gestion claves usuarios update
    * def rutCliente = karate.get('__gatling.RUT', '0099963662')
    * def rutUsuario = karate.get('__gatling.RUT', '0099963662')
    * def token = call token2token {'rutUsuario':'#(rutUsuario)','rutCliente':'#(rutCliente)','basicAuth':'#(basicAuth.AutenticacionOauth)'}
    * def encriptaClave = call encriptado {'clave':'#(claveClasica)'})
    * header x-rut-cliente = rutCliente
    * header x-rut-usuario = rutUsuario
    * header trx-id = '1'
    * header trx-canal = 'IP'
    * header trx-ip-origen = '127.0.1.0'
    * header Content-Type = 'application/json'
    * header Authorization = token.tokenAccess + ' ' + token.tokenResponse
    * def respuesta =
    """
        {
          "status": "#string",
          "glosa": "#string"
        }
    """
    Given url urls.pathBaseAPIGeeDMZ
    And path 'api-gestion-claves-usuarios', 'api', 'v1', 'user-password', 'update'
    And request payload
    When method PUT
    Then status 200
    And match response == respuesta

  @actualizo
  Scenario: Update base
    * def rut = '0156404179'
    * def claveClasica = '5678'
    * def rutCliente = rut
    * def rutUsuario = rut
    * def token = call token2token {'rutUsuario':'#(rutUsuario)','rutCliente':'#(rutCliente)','basicAuth':'#(basicAuth.AutenticacionOauth)'}
    * def encriptaClave = call encriptado {'clave':'#(claveClasica)'})
    * header x-rut-cliente = rutCliente
    * header x-rut-usuario = rutUsuario
    * header trx-id = '1'
    * header trx-canal = 'IP'
    * header trx-ip-origen = '127.0.1.0'
    * header Content-Type = 'application/json'
    * header Authorization = token.tokenAccess + ' ' + token.tokenResponse
    * def respuesta =
    """
        {
          "status": "#string",
          "glosa": "#string"
        }
    """
    Given url urls.pathBaseAPIGeeDMZ
    And path 'api-gestion-claves-usuarios', 'api', 'v1', 'user-password', 'update'
    And request
    """
      {
        "clave": #(encriptaClave.AES),
        "claveDobleEncriptada": #(encriptaClave.RSA)
      }
    """
    When method PUT
    Then status 200
    And match response == respuesta

  @TestCase=NEW
  @tagADO=update_200
    Scenario Outline: Actualizacion de clave - status 200
    * def token = call token2token {'rutUsuario':'<rutUsuario>','rutCliente':'<rutCliente>','basicAuth':'#(basicAuth.AutenticacionOauth)'}
    * def encriptaClave = call encriptado {'clave':'<claveClasica>'})
    * header x-rut-cliente = '<rutCliente>'
    * header x-rut-usuario = '<rutUsuario>'
    * header trx-id = '1'
    * header trx-canal = 'IP'
    * header trx-ip-origen = '127.0.1.0'
    * header Content-Type = 'application/json'
    * header Authorization = token.tokenAccess + ' ' + token.tokenResponse
    Given url urls.pathBaseAPIGeeDMZ
    And path 'api-gestion-claves-usuarios', 'api', 'v1', 'user-password', 'update'
    And request
    """
      {
        "clave": #(encriptaClave.AES),
        "claveDobleEncriptada": #(encriptaClave.RSA)
      }
    """
    When method PUT
    Then status 200
    And match response.status == '<status>'
    And match response.glosa == '<glosa>'
    Examples:
    |rutUsuario|rutCliente|claveClasica|status|glosa                     |
    |010024814K|010024814K|1234        |ok    |clave personas actualizada|
    #|0044397927|0044397927|5678        |ok    |clave empresas actualizada|
