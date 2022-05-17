# df-to-List-of-Lists
Create a list of lists compliant to the ConcePTION ecosystem from a data.frame

## Usage

x is a data.frame object with at least columns code, coding_system and event_abbreviation
codying_system_recode can be:

 * "Auto" (default value) -> recode the codying_system column using the default values inside the function
 * False -> do nothing
 * a custom df -> use the df to recode the codying_system column. The df should have as the first two columns the old names and the new names respectively

The function return the a list of list compliant to the ConcePTION ecosystem

## Creation of input data.frame

Input data.frame can be created using the script at [this repository](https://github.com/VAC4EU/Codelist-creation)
