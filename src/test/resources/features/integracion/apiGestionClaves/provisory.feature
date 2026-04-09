Feature: Prueba para Ron Dany

  Background:
    * def encryptUtils = Java.type('utils.EncryptUtils')
    * def clave = Java.type('utils.PasswordUtils')
    * def encriptar_Clave = read('classpath:features/steps/encriptarClave.feature@encriptarClave')


  # ═══════════════════════════════════════════════════════════════

  # ESCENARIOS 200 - Casos de éxito

  # ═══════════════════════════════════════════════════════════════

  @TestCase=NEW
  @tagADO=provisory_200
  Scenario Outline: Clave Provisoria - status 200 (Clave Random)
    * def claveProvisoria = clave.generarClaveRandom(<cantidadLetras>, <cantidadNumeros>)
    * def encriptadoAlpha = encryptUtils.encryptTeloV2(claveProvisoria)
    * def claveEncriptada = call encriptar_Clave { clave: '#(claveProvisoria)' }
    * def tipoCliente = '<tipoCliente>'
    * header Content-type = 'application/json'
    * header x-rut-usuario = '<rutUsuario>'
    * header x-rut-cliente = '<rutCliente>'
    * header trx-canal = 'IP'
    * header trx-ip-canal = '127.0.1.0'
    * header trx-id = '1'
    * def body =
    """
      {
        "rut": "<rut>",
        "canal": "PORTAL",
        "ipOrigen": "127.0.1.0",
        "usuario": "SMARTINEZ",
        "sucursal": "01",
        "clave": #(encriptadoAlpha),
        "tipoCliente": "5",
        "claveRsa": #(claveEncriptada.encriptada)
      }
    """
    Given url urls.APIqa
    And path 'api-gestion-claves-usuarios', 'api', 'v1', 'user-password', 'provisory'
    And request body
    When method POST
    Then status 200
    Examples:
      |cantidadLetras|cantidadNumeros|tipoCliente      |rutUsuario|rutCliente|rut       |
      |4             |4              |Alpha Personas   |0099756969|0099756969|0099756969|
      |4             |4              |Transmit Personas|0099751142|0099751142|0099751142|