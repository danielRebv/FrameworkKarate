Feature: Headers

  Scenario:
    * def cuentasHeaders =
  """
  {
    Content-Type: 'application/json',
    canal: 'web'
  }
  """
    * def pagosHeaders =
  """
  {
    Content-Type: 'application/json',
    canal: 'mobile'
  }
  """