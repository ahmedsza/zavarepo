Feature: Application Navigation
  As an administrator
  I want to navigate between the different sections of the ZAVA portal
  So that I can access all management features from a single page application

  Background:
    Given the ZAVA portal is open in the browser

  # ── Happy Path ────────────────────────────────────────────────────────────────

  Scenario: Home page is displayed on initial load
    Then the "HOME" page section is visible
    And the page heading "BACKOFFICE MANAGEMENT PORTAL" is displayed
    And the navigation bar shows the ZAVA logo

  Scenario: Navigate to the About page
    When the user clicks the "ABOUT" navigation link
    Then the "ABOUT" page section is visible
    And the heading "ABOUT ZAVA" is displayed
    And the "HOME" page section is hidden

  Scenario: Navigate to the Products page
    When the user clicks the "PRODUCTS" navigation link
    Then the "PRODUCTS" page section is visible
    And the heading "PRODUCT MANAGEMENT" is displayed

  Scenario: Navigate to the Sales page
    When the user clicks the "SALES" navigation link
    Then the "SALES" page section is visible
    And the heading "CUSTOMER SALES SUMMARY" is displayed

  Scenario: Navigate to the Stores page
    When the user clicks the "STORES" navigation link
    Then the "STORES" page section is visible
    And the text "STORE FINDER" is displayed
    And the text "COMING SOON" is displayed

  Scenario: Navigate to the Contact page
    When the user clicks the "CONTACT" navigation link
    Then the "CONTACT" page section is visible
    And the text "CONTACT US" is displayed
    And the text "COMING SOON" is displayed

  Scenario: Navigate back to the Home page from another section
    Given the user has navigated to the "ABOUT" page
    When the user clicks the "HOME" navigation link
    Then the "HOME" page section is visible
    And the heading "BACKOFFICE MANAGEMENT PORTAL" is displayed

  Scenario: Use the hero CTA button to navigate to Products
    Given the user is on the "HOME" page
    When the user clicks the "MANAGE PRODUCTS" button
    Then the "PRODUCTS" page section is visible
    And the heading "PRODUCT MANAGEMENT" is displayed

  Scenario: Use the hero CTA button to navigate to About
    Given the user is on the "HOME" page
    When the user clicks the "ABOUT SYSTEM" button
    Then the "ABOUT" page section is visible

  Scenario: Navigate to Products via the footer quick link
    When the user clicks the "Products" link in the footer
    Then the "PRODUCTS" page section is visible

  Scenario Outline: All navigation links reach their correct pages
    When the user clicks the "<link>" navigation link
    Then the "<page_heading>" heading is displayed
    Examples:
      | link     | page_heading                    |
      | HOME     | BACKOFFICE MANAGEMENT PORTAL    |
      | ABOUT    | ABOUT ZAVA                      |
      | PRODUCTS | PRODUCT MANAGEMENT              |
      | SALES    | CUSTOMER SALES SUMMARY          |

  # ── Active State ──────────────────────────────────────────────────────────────

  Scenario: The active navigation link is highlighted
    When the user clicks the "PRODUCTS" navigation link
    Then the "PRODUCTS" link in the navigation bar has the active style

  # ── Mobile Navigation ─────────────────────────────────────────────────────────

  Scenario: Mobile menu is hidden by default on small screens
    Given the browser viewport is set to a mobile size
    Then the desktop navigation menu is not visible
    And the mobile hamburger button is visible

  Scenario: Open and close the mobile menu
    Given the browser viewport is set to a mobile size
    When the user taps the hamburger menu button
    Then the mobile navigation menu becomes visible
    When the user taps the hamburger menu button again
    Then the mobile navigation menu is hidden

  Scenario: Navigate using the mobile menu
    Given the browser viewport is set to a mobile size
    When the user taps the hamburger menu button
    And the user taps "PRODUCTS" in the mobile menu
    Then the "PRODUCTS" page section is visible
    And the mobile navigation menu is hidden

  # ── Page Scroll ───────────────────────────────────────────────────────────────

  Scenario: Switching pages scrolls back to the top
    Given the user has scrolled to the bottom of the page
    When the user clicks the "ABOUT" navigation link
    Then the page is scrolled to the top
