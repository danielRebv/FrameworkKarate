@test
Feature: Obtener token Edgemicro
  Scenario: Obtener token client_credentials
    Given url urls.auth
    And path 'edgemicro-auth/token'
    And header Authorization = 'Basic UXRIa3NzUXlFdElMMkJENm9oNzdDSHBmcUFZS1VVRzM6YUREOFpHdmFZV2I0ajFNVA=='
    And header Content-Type = 'application/x-www-form-urlencoded'
    And header x-rut-cliente = '001226769K'
    And header x-rut-usuario = '001226769K'
    And form field grant_type = 'client_credentials'
    When method POST
    Then status 200
    And match response.access_token != null
    And match response.token_type == 'Bearer'
