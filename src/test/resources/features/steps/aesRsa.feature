Feature: API Encriptacion de clave
  Background:
    * def content = 'application/json'
    * header accept = content
    * header Content-Type = content
    * def clave = karate.get('nvaClave')
    * def fixedClave = '5678'

  @claveEncriptada @claveAES @claveRSA
  Scenario: Encriptar Clave
    Given url urls.pathAes
    And path 'ocp', 'cnl-trvl', 'autenticacion', 'clave-acceso', 'v1', 'encriptaClave'
    And request
    """
       {
          "claveEnClaro": '#(clave)'
       }
    """
    When method POST
    Then  status 200
    * def AES = response.claveAes
    * def RSA = response.claveRsa