Feature:

  @whitelist
  Scenario: Performance Whitelist (Rut en MongoDB)
    * def rutPerf = karate.get('__gatling.rut', '0060623538')
    * header Content-Type = 'application/json'
    Given url urls.common
    And path 'ms-whitelist', 'v1', 'whitelist'
    And request
        """
        {
          "rut": '#(rutPerf)',
          "flujo": "RUT_FYF_TRANSMIT"
        }
        """
    When method POST
    Then status 200