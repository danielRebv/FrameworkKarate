Feature: API Encriptacion de clave
  Background:
    * url pathAes
    * def content = 'application/json'
    * header accept = content
    * header Content-Type = content
    * def body = read('classpath:helpers/schema/payload/aesRsaPayload.json')
    * def clave = karate.get('nvaClave')
    * def fixedClave = '5678'

  @claveEncriptada @claveAES @claveRSA
  Scenario: Encriptar Clave
    Given path '/ocp/cnl-trvl/autenticacion/clave-acceso/v1/encriptaClave'
    * set body.clave = clave ? clave : fixedClave
    And request body
    When method POST
    Then  status 200
    * def AES = response.claveAes
    * def RSA = response.claveRsa