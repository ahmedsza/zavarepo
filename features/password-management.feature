Feature: Password Management
  As a developer
  I want the application to enforce strong passwords and securely hash them
  So that user credentials are protected

  # ── Password Strength Validation ─────────────────────────────────────────────

  Scenario: A password meeting all requirements is considered strong
    Given a password "SecureP@ss1"
    When the password strength is checked
    Then the password is considered strong

  Scenario Outline: Passwords meeting all complexity rules are accepted
    When the password strength of "<password>" is checked
    Then the password is considered strong
    Examples:
      | password         |
      | Abcdefg1!        |
      | P@ssw0rd         |
      | MyStr0ng#Pass    |
      | Zh8$kQr2mN       |

  Scenario: Password shorter than 8 characters is weak
    Given a password "Ab1!"
    When the password strength is checked
    Then the password is considered weak

  Scenario: Password without an uppercase letter is weak
    Given a password "password1!"
    When the password strength is checked
    Then the password is considered weak

  Scenario: Password without a lowercase letter is weak
    Given a password "PASSWORD1!"
    When the password strength is checked
    Then the password is considered weak

  Scenario: Password without a digit is weak
    Given a password "Password!"
    When the password strength is checked
    Then the password is considered weak

  Scenario: Password without a special character is weak
    Given a password "Password1"
    When the password strength is checked
    Then the password is considered weak

  Scenario: An empty string password is weak
    Given a password ""
    When the password strength is checked
    Then the password is considered weak

  Scenario Outline: Various weak passwords are rejected
    When the password strength of "<password>" is checked
    Then the password is considered weak
    Examples:
      | password   |
      | short1!    |
      | alllower1! |
      | ALLUPPER1! |
      | NoDigits!  |
      | NoSpecial1 |
      | abcdefgh   |

  # ── Password Boundary Conditions ─────────────────────────────────────────────

  Scenario: Password of exactly 8 characters meeting all rules is strong
    Given a password "Aa1!Bb2@"
    When the password strength is checked
    Then the password is considered strong

  Scenario: Password of exactly 7 characters is weak even if otherwise complex
    Given a password "Aa1!Bb2"
    When the password strength is checked
    Then the password is considered weak

  # ── Password Hashing ─────────────────────────────────────────────────────────

  Scenario: Hashing a password returns a non-empty string
    Given a password "MyPassword1!"
    When the password is hashed
    Then the hash is a non-empty string

  Scenario: The hash is a valid SHA-256 hex digest
    Given a password "MyPassword1!"
    When the password is hashed
    Then the hash is a 64-character hexadecimal string

  Scenario: Hashing the same password twice produces the same hash
    Given a password "ConsistentP@ss1"
    When the password is hashed twice
    Then both hashes are identical

  Scenario: Different passwords produce different hashes
    Given a password "FirstP@ss1"
    And another password "SecondP@ss1"
    When both passwords are hashed
    Then the two hashes are different

  Scenario: The original password cannot be read from the hash
    Given a password "S3cretP@ss"
    When the password is hashed
    Then the hash does not contain the original password text
