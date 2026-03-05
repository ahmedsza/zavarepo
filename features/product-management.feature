Feature: Product Management
  As an administrator
  I want to manage the product catalog
  So that I can maintain accurate inventory information

  Background:
    Given the user is on the "PRODUCTS" page
    And the product list has been loaded

  # ── Happy Path: Add Product ───────────────────────────────────────────────────

  Scenario: Open the Add Product modal
    When the user clicks the "+ ADD PRODUCT" button
    Then the product modal is displayed
    And the modal title reads "ADD NEW PRODUCT"
    And the submit button reads "ADD PRODUCT"
    And all form fields are empty

  Scenario: Add a product with only the required name field
    When the user clicks the "+ ADD PRODUCT" button
    And the user enters "Test Gadget" in the product name field
    And the user clicks the "ADD PRODUCT" button
    Then a success alert "Product added successfully!" is displayed
    And the product modal is closed
    And "Test Gadget" appears in the product table

  Scenario: Add a fully-detailed product
    When the user clicks the "+ ADD PRODUCT" button
    And the user enters "Premium Headphones" in the product name field
    And the user enters "High-quality wireless headphones with noise cancellation" in the description field
    And the user enters "299.99" in the price field
    And the user selects "Electronics" from the category dropdown
    And the user clicks the "ADD PRODUCT" button
    Then a success alert "Product added successfully!" is displayed
    And "Premium Headphones" appears in the product table
    And the price "$299.99" is shown for "Premium Headphones"
    And the category "Electronics" is shown for "Premium Headphones"

  Scenario Outline: Add products in each available category
    When the user clicks the "+ ADD PRODUCT" button
    And the user enters "<product_name>" in the product name field
    And the user selects "<category>" from the category dropdown
    And the user clicks the "ADD PRODUCT" button
    Then a success alert "Product added successfully!" is displayed
    And "<product_name>" appears in the product table
    Examples:
      | product_name         | category        |
      | Widget Pro           | General         |
      | Smart TV 55"         | Electronics     |
      | Running Shoes        | Sports          |
      | Mystery Novel        | Books           |
      | Organic Tea          | Food & Beverage |
      | Kids Puzzle Set      | Toys            |
      | Face Moisturiser     | Health & Beauty |
      | Car Phone Mount      | Automotive      |
      | Linen Bed Sheet      | Home & Garden   |
      | Cotton T-Shirt       | Clothing        |

  # ── Happy Path: Edit Product ──────────────────────────────────────────────────

  Scenario: Open the Edit Product modal for an existing product
    Given a product "Sample Widget" exists in the catalog
    When the user clicks the "EDIT" button for "Sample Widget"
    Then the product modal is displayed
    And the modal title reads "EDIT PRODUCT"
    And the submit button reads "UPDATE PRODUCT"
    And the product name field contains "Sample Widget"

  Scenario: Update a product name
    Given a product "Old Product Name" exists in the catalog
    When the user clicks the "EDIT" button for "Old Product Name"
    And the user clears the product name field
    And the user enters "New Product Name" in the product name field
    And the user clicks the "UPDATE PRODUCT" button
    Then a success alert "Product updated successfully!" is displayed
    And "New Product Name" appears in the product table
    And "Old Product Name" no longer appears in the product table

  Scenario: Update a product price and category
    Given a product "Adjustable Desk" exists in the catalog with price 150.00 and category "General"
    When the user clicks the "EDIT" button for "Adjustable Desk"
    And the user enters "199.99" in the price field
    And the user selects "Home & Garden" from the category dropdown
    And the user clicks the "UPDATE PRODUCT" button
    Then a success alert "Product updated successfully!" is displayed
    And the price "$199.99" is shown for "Adjustable Desk"
    And the category "Home & Garden" is shown for "Adjustable Desk"

  # ── Happy Path: Delete Product ────────────────────────────────────────────────

  Scenario: Delete a product with confirmation
    Given a product "Disposable Item" exists in the catalog
    When the user clicks the "DELETE" button for "Disposable Item"
    And the user confirms the deletion dialog
    Then a success alert "Product deleted successfully!" is displayed
    And "Disposable Item" no longer appears in the product table

  Scenario: Cancel product deletion
    Given a product "Keeper Product" exists in the catalog
    When the user clicks the "DELETE" button for "Keeper Product"
    And the user cancels the deletion dialog
    Then "Keeper Product" still appears in the product table

  # ── Happy Path: Search and Filter ────────────────────────────────────────────

  Scenario: Search products by name
    Given the catalog contains products "Wireless Mouse", "Wireless Keyboard", and "USB Hub"
    When the user types "Wireless" in the search input
    Then "Wireless Mouse" is visible in the product table
    And "Wireless Keyboard" is visible in the product table
    And "USB Hub" is not visible in the product table

  Scenario: Search is case-insensitive
    Given the catalog contains a product "Bluetooth Speaker"
    When the user types "bluetooth" in the search input
    Then "Bluetooth Speaker" is visible in the product table

  Scenario: Search matches the product description
    Given a product "Noise Cancelling Headset" with description "Crystal-clear audio" exists
    When the user types "Crystal-clear" in the search input
    Then "Noise Cancelling Headset" is visible in the product table

  Scenario: Filter products by category
    Given the catalog contains "Laptop Stand" in "Electronics" and "Yoga Mat" in "Sports"
    When the user selects "Electronics" from the category filter dropdown
    Then "Laptop Stand" is visible in the product table
    And "Yoga Mat" is not visible in the product table

  Scenario: Combine search and category filter
    Given the catalog contains "Running Shoes" in "Sports" and "Running Shorts" in "Clothing"
    When the user types "Running" in the search input
    And the user selects "Sports" from the category filter dropdown
    Then "Running Shoes" is visible in the product table
    And "Running Shorts" is not visible in the product table

  Scenario: Clear category filter to show all products
    Given the catalog contains "Laptop Stand" in "Electronics" and "Yoga Mat" in "Sports"
    And the user has filtered by "Electronics"
    When the user selects "All Categories" from the category filter dropdown
    Then both "Laptop Stand" and "Yoga Mat" are visible in the product table

  # ── Edge Cases ───────────────────────────────────────────────────────────────

  Scenario: Empty catalog shows no-products state
    Given the product catalog is empty
    Then the message "No Products Yet" is displayed
    And the message "Start by adding your first product" is displayed

  Scenario: Search with no matching results shows empty table
    Given the catalog contains products "Apple" and "Banana"
    When the user types "Zucchini" in the search input
    Then no products are displayed in the table

  Scenario: Product price defaults to 0.00 when not provided
    When the user clicks the "+ ADD PRODUCT" button
    And the user enters "Free Sample" in the product name field
    And the user clicks the "ADD PRODUCT" button
    Then the price "$0.00" is shown for "Free Sample"

  Scenario: Product category defaults to General when not selected
    When the user clicks the "+ ADD PRODUCT" button
    And the user enters "Default Category Product" in the product name field
    And the user clicks the "ADD PRODUCT" button
    Then the category "General" is shown for "Default Category Product"

  # ── Error Scenarios ──────────────────────────────────────────────────────────

  Scenario: Submitting the Add Product form without a name shows an error
    When the user clicks the "+ ADD PRODUCT" button
    And the user clicks the "ADD PRODUCT" button without entering a name
    Then an error alert "Product name is required" is displayed
    And the product modal remains open

  # ── Modal Dismissal ──────────────────────────────────────────────────────────

  Scenario: Close the modal using the X button
    Given the product modal is open
    When the user clicks the close (×) button
    Then the product modal is no longer visible

  Scenario: Close the modal using the Cancel button
    Given the product modal is open
    When the user clicks the "CANCEL" button
    Then the product modal is no longer visible

  Scenario: Close the modal by clicking the backdrop
    Given the product modal is open
    When the user clicks outside the modal dialog
    Then the product modal is no longer visible

  Scenario: Opening a new Add Product modal resets the form
    Given the user has previously filled the product form without submitting
    When the user closes the modal
    And the user reopens the Add Product modal
    Then all form fields are empty

  # ── Accessibility ────────────────────────────────────────────────────────────

  Scenario: Search input has an accessible label
    Then the search input has the aria-label "Search products"

  Scenario: Category filter has an accessible label
    Then the category filter dropdown has the aria-label "Filter by category"

  Scenario: Product name input is marked as required
    When the user opens the Add Product modal
    Then the product name input has the attribute aria-required set to "true"

  Scenario: Edit and Delete action buttons have accessible labels
    Given a product "Accessible Item" exists in the catalog
    Then the EDIT button for "Accessible Item" has an aria-label containing "Edit Accessible Item"
    And the DELETE button for "Accessible Item" has an aria-label containing "Delete Accessible Item"

  Scenario: Alert messages are announced to screen readers
    When the user adds a product successfully
    Then the success alert element has the role "alert"
