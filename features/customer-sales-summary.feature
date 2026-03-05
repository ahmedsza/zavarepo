Feature: Customer Sales Summary
  As an administrator
  I want to view the customer sales summary data from the database
  So that I can monitor sales performance and make informed decisions

  Background:
    Given the user is on the "SALES" page

  # ── Happy Path ────────────────────────────────────────────────────────────────

  Scenario: Sales data loads automatically when navigating to the Sales page
    Then the sales data loading request is sent to "/customer-sales-summary"
    And a table of sales data is displayed
    And the table includes a header row with column names

  Scenario: Sales data table shows customer records
    Given the database contains customer sales records
    When the sales data has loaded
    Then the sales table is visible
    And at least one customer row is displayed

  Scenario: Load sales data by clicking the "LOAD DATA" button
    When the user clicks the "LOAD DATA" button
    Then the sales loading indicator is shown briefly
    And a table of sales data is displayed

  Scenario: Loading indicator appears while data is being fetched
    When the user clicks the "LOAD DATA" button
    Then the "Loading sales data..." message is shown
    And the message disappears once the data is displayed

  # ── Filtering ─────────────────────────────────────────────────────────────────

  Scenario: Filter sales data by customer name
    Given the sales data has loaded and includes a customer named "John Smith"
    When the user types "John" in the customer name filter
    And the user clicks the "LOAD DATA" button
    Then the results include rows for customers matching "John"
    And customers not matching "John" are not displayed

  Scenario: Name filter is case-insensitive
    Given the sales data includes a customer named "Alice Johnson"
    When the user types "alice" in the customer name filter
    And the user clicks the "LOAD DATA" button
    Then the results include the row for "Alice Johnson"

  Scenario: Empty name filter returns all records
    When the customer name filter is empty
    And the user clicks the "LOAD DATA" button
    Then all available sales records are displayed

  Scenario: Filter with no matching customers shows empty state
    When the user types "ZZZNOMATCH999" in the customer name filter
    And the user clicks the "LOAD DATA" button
    Then the message "No Sales Data" is displayed
    And the message "No records matched your filter criteria." is displayed

  # ── Pagination ────────────────────────────────────────────────────────────────

  Scenario: Pagination controls are displayed when data loads
    Given the sales data has loaded
    Then the pagination section is visible
    And the page indicator shows "Page 1"
    And a row count summary is displayed

  Scenario Outline: Change the number of rows displayed per page
    When the user selects "<rows>" from the rows-per-page dropdown
    And the user clicks the "LOAD DATA" button
    Then the sales table shows at most <rows> rows
    Examples:
      | rows |
      | 25   |
      | 50   |
      | 100  |
      | 250  |
      | 500  |

  Scenario: Navigate to the next page of results
    Given the sales data spans more than one page
    When the user clicks the "NEXT" button
    Then the page indicator shows "Page 2"
    And the "PREV" button becomes enabled

  Scenario: Navigate to the previous page of results
    Given the user is on page 2 of the sales results
    When the user clicks the "PREV" button
    Then the page indicator shows "Page 1"
    And the "PREV" button is disabled

  Scenario: The "PREV" button is disabled on the first page
    Given the sales data has loaded on page 1
    Then the "PREV" button is disabled

  Scenario: The "NEXT" button is disabled on the last page
    Given the user has navigated to the last page of results
    Then the "NEXT" button is disabled

  Scenario: Row count summary reflects the current page
    Given the sales data has loaded
    Then the row summary shows "Showing X of Y rows" where X is the page size and Y is the total

  # ── Edge Cases ────────────────────────────────────────────────────────────────

  Scenario: Sales page shows empty state when no records are returned
    Given the database returns no sales records
    When the sales data has loaded
    Then the message "No Sales Data" is displayed

  # ── Error Scenarios ──────────────────────────────────────────────────────────

  Scenario: An error alert is shown when the sales API returns an error
    Given the "/customer-sales-summary" endpoint returns an error response
    When the user clicks the "LOAD DATA" button
    Then an error alert is displayed containing the error message
    And the sales table is not shown

  Scenario: An error alert is shown when the network request fails
    Given the network is unavailable
    When the user clicks the "LOAD DATA" button
    Then an error alert is displayed with "Error loading sales data:"
    And the loading indicator disappears

  # ── Accessibility ────────────────────────────────────────────────────────────

  Scenario: Customer name filter has an accessible label
    Then the customer name filter input has the aria-label "Filter by customer name"

  Scenario: Rows-per-page dropdown has an accessible label
    Then the rows-per-page dropdown has the aria-label "Rows per page"
