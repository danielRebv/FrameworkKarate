Feature: Generacion de token
  Background:
    * def rutCliente = karate.get('rutCliente')
    * def rutUsuario = karate.get('rutUsuario')
    * def fixedRut = '0044397927'
    * def basicAuth = 'Basic UXRIa3NzUXlFdElMMkJENm9oNzdDSHBmcUFZS1VVRzM6YUREOFpHdmFZV2I0ajFNVA=='
    * configure headers = { 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0 Safari/537.36', Accept: '*/*' }

  @token2token
  Scenario: Solicitar access_token con client_credentials
    Given url urls.gw_edge_micro
    And path '/edgemicro-auth/token'
    * header Authorization = basicAuth
    * header Content-Type = 'application/x-www-form-urlencoded'
    * header x-rut-cliente = rutCliente ? rutCliente : fixedRut
    * header x-rut-usuario = rutUsuario ? rutUsuario : fixedRut
    And form field grant_type = 'client_credentials'
    When method POST
    * def tokenResponse = response.token
    * def tokenAccess = response.token_type