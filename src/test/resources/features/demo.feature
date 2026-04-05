Feature: Demo PRO multi escenarios

  Scenario: GET cuentas 1
    * def headers = buildHeaders('cuentas')
    Given url services.demo
    And path 'posts','1'
    And headers headers
    When method GET
    Then status 200


  Scenario: GET cuentas 2
    * def headers = buildHeaders('cuentas')
    Given url services.demo
    And path 'posts','2'
    And headers headers
    When method GET
    Then status 200

  Scenario: GET pagos 1
    * def headers = buildHeaders('pagos')

    Given url services.demo
    And path 'posts','3'
    And headers headers
    When method GET
    Then status 200


  Scenario: GET pagos 2
    * def headers = buildHeaders('pagos')
    Given url services.demo
    And path 'posts','4'
    And headers headers
    When method GET
    Then status 200