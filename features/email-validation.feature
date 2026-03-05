Feature: Email Address Validation
  As a developer
  I want the application to validate email addresses
  So that only properly formatted emails are accepted by the system

  # ── Happy Path: Valid Emails ──────────────────────────────────────────────────

  Scenario Outline: Valid email addresses are accepted
    When the email address "<email>" is validated
    Then the result is valid
    Examples:
      | email                          |
      | user@example.com               |
      | user.name+tag@sub.domain.co    |
      | user_name@domain.org           |
      | user-name@domain.io            |
      | user123@domain123.com          |
      | u@d.co                         |
      | user.name@domain.travel        |
      | user@localhost.localdomain     |

  # ── Edge Cases: Valid Formats ──────────────────────────────────────────────────

  Scenario: Email with a single-character local part is valid
    When the email address "a@b.co" is validated
    Then the result is valid

  Scenario: Email with multiple subdomains is valid
    When the email address "user@mail.subdomain.example.com" is validated
    Then the result is valid

  Scenario: Email with numeric domain labels is valid
    When the email address "user123@domain123.com" is validated
    Then the result is valid

  # ── Error Scenarios: Invalid Emails ──────────────────────────────────────────

  Scenario Outline: Invalid email addresses are rejected
    When the email address "<email>" is validated
    Then the result is invalid
    Examples:
      | email                    |
      | plainaddress             |
      | @missingusername.com     |
      | username@.com            |
      | username@com             |
      | username@domain..com     |
      | username@domain.c        |
      | username@domain.corporate1 |
      | user name@domain.com     |
      | user@domain,com          |
      | user@domain              |
      | user@.domain.com         |
      | user@domain.com.         |

  Scenario: An empty string is not a valid email
    When the email address "" is validated
    Then the result is invalid

  Scenario: A null value is not a valid email
    When a null email is validated
    Then the result is invalid

  Scenario: Email with spaces in the local part is rejected
    When the email address "user name@domain.com" is validated
    Then the result is invalid

  Scenario: Email missing the "@" symbol is rejected
    When the email address "userdomain.com" is validated
    Then the result is invalid

  Scenario: Email missing the domain is rejected
    When the email address "user@" is validated
    Then the result is invalid

  Scenario: Email with consecutive dots in the domain is rejected
    When the email address "user@domain..com" is validated
    Then the result is invalid

  Scenario: Email with a top-level domain of only one character is rejected
    When the email address "user@domain.c" is validated
    Then the result is invalid

  Scenario: Email with a TLD that contains digits is rejected
    When the email address "username@domain.corporate1" is validated
    Then the result is invalid
