## Prerequisites

To follow best practices on using schemachange in a CICD pipeline, you will need to review and run statements in the provision folder or set up your own database and schema.

-   initialize.sql: Contains the SQL variables to initialize your environment.
-   setup_schemachange_schema.sql: Contains the SQL variables to track the individual demo scenarios in its own change history table.

## Change Scripts

### Versioned Script Naming

Versioned change scripts follow a similar naming convention to that used
by [Flyway Versioned Migrations](https://flywaydb.org/documentation/migrations#versioned-migrations). The script name
must follow this pattern (image taken
from [Flyway docs](https://flywaydb.org/documentation/migrations#versioned-migrations)):

<img src="images/flyway-naming-convention.png" alt="Flyway naming conventions" title="Flyway naming conventions" width="300" />

With the following rules for each part of the filename:

* **Prefix**: The letter 'V' for versioned change
* **Version**: A unique version number with dots or underscores separating as many number parts as you like
* **Separator**: __ (two underscores)
* **Description**: An arbitrary description with words separated by underscores or spaces (can not include two
  underscores)
* **Suffix**: .sql or .sql.jinja

For example, a script name that follows this convention is: `V1.1.1__first_change.sql`. As with Flyway, the unique
version string is very flexible. You just need to be consistent and always use the same convention, like 3 sets of
numbers separated by periods. Here are a few valid version strings:

* 1.1
* 1_1
* 1.2.3
* 1_2_3

Every script within a database folder must have a unique version number. schemachange will check for duplicate version
numbers and throw an error if it finds any. This helps to ensure that developers who are working in parallel don't
accidentally (re-)use the same version number.

### Repeatable Script Naming

Repeatable change scripts follow a similar naming convention to that used
by [Flyway Versioned Migrations](https://flywaydb.org/documentation/concepts/migrations.html#repeatable-migrations). The
script name must follow this pattern (image taken
from [Flyway docs](https://flywaydb.org/documentation/concepts/migrations.html#repeatable-migrations):

<img src="images/flyway-repeatable-naming-convention.png" alt="Flyway naming conventions" title="Flyway naming conventions" width="300" />

e.g:

* R__sp_add_sales.sql
* R__fn_get_timezone.sql
* R__fn_sort_ascii.sql

All repeatable change scripts are applied each time the utility is run, if there is a change in the file.
Repeatable scripts could be used for maintaining code that always needs to be applied in its entirety. e.g. stores
procedures, functions and view definitions etc.

Just like Flyway, within a single migration run, repeatable scripts are always applied after all pending versioned
scripts have been executed. Repeatable scripts are applied in alphabetical order of their description.

### Always Script Naming

Always change scripts are executed with every run of schemachange. This is an addition to the implementation
of [Flyway Versioned Migrations](https://flywaydb.org/documentation/concepts/migrations.html#repeatable-migrations).
The script name must follow this pattern:

`A__Some_description.sql`

e.g.

* A__add_user.sql
* A__assign_roles.sql

This type of change script is useful for an environment set up after cloning. Always scripts are applied always last.
