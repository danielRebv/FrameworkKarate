Feature: Encriptar clave
  Background:
    * def encabezados = {"accept": "application/json", "trx-canal": "IP", "Content-Type": "application/json"}
    * headers encabezados
    * def fixedClave = '5678'

  @encriptarClave
  Scenario: Encriptar clave
    * def clave = clave ? clave : fixedClave
    * def body =
      """
        {
          "claveEnClaro": '#(clave)'
        }
      """
    Given url urls.EncriptadOCP
    And path 'ocp', 'autenticacion', 'usuarios' ,'v2', 'encriptar'
    And request body
    When method POST
    Then status 200
    * def encriptada = response.claveEncriptada