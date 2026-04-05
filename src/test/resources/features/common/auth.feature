Feature: Auth demo

  Scenario: generar token fake

    Given url 'https://jsonplaceholder.typicode.com'
    And path 'posts','1'
    When method GET
    Then status 200

    * def token = 'fake-token-' + response.id