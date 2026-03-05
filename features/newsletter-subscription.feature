Feature: Newsletter Subscription
  As a visitor
  I want to subscribe to the ZAVA newsletter
  So that I can receive platform updates and feature announcements

  Background:
    Given the ZAVA portal is open in the browser
    And the footer is visible on the page

  # ── Happy Path ────────────────────────────────────────────────────────────────

  Scenario: Subscribe with a valid email address
    When the user enters "admin@example.com" in the newsletter email field
    And the user clicks the "SUBSCRIBE" button
    Then a success alert is displayed containing "Thank you for subscribing with admin@example.com"
    And the newsletter email field is cleared

  Scenario Outline: Subscribe with various valid email addresses
    When the user enters "<email>" in the newsletter email field
    And the user clicks the "SUBSCRIBE" button
    Then a success alert is displayed containing "Thank you for subscribing with <email>"
    Examples:
      | email                    |
      | manager@company.org      |
      | ops.admin@zava-corp.com  |
      | user123@domain.io        |

  # ── Edge Cases ────────────────────────────────────────────────────────────────

  Scenario: Newsletter form is reset after successful subscription
    When the user subscribes with "reset.test@example.com"
    Then the newsletter email field is empty

  # ── Error / Validation Scenarios ─────────────────────────────────────────────

  Scenario: Submitting the newsletter form with an empty email is prevented
    When the user submits the newsletter form without entering an email
    Then no subscription alert is shown
    And the browser's built-in validation prevents the form from submitting

  Scenario: Submitting the newsletter form with an invalid email is prevented
    When the user enters "not-an-email" in the newsletter email field
    And the user clicks the "SUBSCRIBE" button
    Then the browser's built-in validation prevents the form from submitting

  # ── Accessibility ────────────────────────────────────────────────────────────

  Scenario: Newsletter email input has an accessible label
    Then the newsletter email input has the aria-label "Email for newsletter"

  Scenario: Newsletter section has a descriptive heading
    Then the footer contains the heading "NEWSLETTER"

  Scenario: Subscribe button is focusable via keyboard
    When the user navigates to the newsletter email input using the Tab key
    And the user enters a valid email address
    And the user presses the Tab key to focus the Subscribe button
    And the user presses the Enter key
    Then a success alert is displayed confirming the subscription
