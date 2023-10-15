
IDENTIFICATION DIVISION.
PROGRAM-ID. CaseManagementSystem.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT CLIENT-FILE ASSIGN TO 'CLIENTFILE.DAT'.
    SELECT CASE-FILE ASSIGN TO 'CASEFILE.DAT'.
    SELECT SERVICE-FILE ASSIGN TO 'SERVICEFILE.DAT'.
    SELECT REPORT-FILE ASSIGN TO 'REPORTFILE.DAT'.

DATA DIVISION.
FILE SECTION.
FD  CLIENT-FILE.
01  CLIENT-RECORD.
    05  CLIENT-ID          PIC 9(5).
    05  CLIENT-NAME        PIC X(50).
    05  CLIENT-ADDRESS     PIC X(100).

FD  CASE-FILE.
01  CASE-RECORD.
    05  CASE-ID            PIC 9(5).
    05  CLIENT-ID          PIC 9(5).
    05  CASE-WORKER-NAME   PIC X(50).

FD  SERVICE-FILE.
01  SERVICE-RECORD.
    05  SERVICE-ID         PIC 9(5).
    05  CLIENT-ID          PIC 9(5).
    05  SERVICE-DATE       PIC 9(8).
    05  SERVICE-TYPE       PIC X(20).
    05  SERVICE-DESCRIPTION PIC X(100).

FD  REPORT-FILE.
01  REPORT-RECORD         PIC X(255).

WORKING-STORAGE SECTION.
01  CHOICE                PIC 9.
01  EOF-FLAG              PIC X VALUE 'N'.
    88  EOF-REACHED       VALUE 'Y'.
01  SEARCH-ID             PIC 9(5).

PROCEDURE DIVISION.
StartProgram.
    PERFORM DisplayMainMenu UNTIL Choice = 6
    DISPLAY "Thank you for using the Case Management System. Goodbye!"
    STOP RUN.

DisplayMainMenu.
    DISPLAY "----------------------------------------"
    DISPLAY "Welcome to the Case Management System"
    DISPLAY "----------------------------------------"
    DISPLAY "1. Create a new client record"
    DISPLAY "2. Create a new case record"
    DISPLAY "3. Log a service provided to a client"
    DISPLAY "4. Generate a report of all records"
    DISPLAY "5. Search for a client record"
    DISPLAY "6. Exit the system"
    DISPLAY "----------------------------------------"
    DISPLAY "Please enter your selection (1-6):"
    ACCEPT Choice
    PERFORM ProcessChoice.

ProcessChoice.
    EVALUATE Choice
        WHEN 1 PERFORM CreateClient
        WHEN 2 PERFORM CreateCase
        WHEN 3 PERFORM LogService
        WHEN 4 PERFORM GenerateReport
        WHEN 5 PERFORM SearchClient
        WHEN OTHER
            DISPLAY "Invalid selection. Please choose a number between 1 and 6."
            PERFORM DisplayMainMenu
    END-EVALUATE.

CreateClient.
    DISPLAY "Please enter the name of the client:"
    ACCEPT CLIENT-NAME
    DISPLAY "Please enter the address of the client:"
    ACCEPT CLIENT-ADDRESS
    DISPLAY "Please enter a unique ID for the client:"
    ACCEPT CLIENT-ID
    OPEN OUTPUT CLIENT-FILE
    WRITE CLIENT-RECORD
    CLOSE CLIENT-FILE
    DISPLAY "The client record has been created successfully."

CreateCase.
    DISPLAY "Please enter the ID of the client for this case:"
    ACCEPT CLIENT-ID
    DISPLAY "Please enter the name of the case worker:"
    ACCEPT CASE-WORKER-NAME
    DISPLAY "Please enter a unique ID for the case:"
    ACCEPT CASE-ID
    OPEN OUTPUT CASE-FILE
    WRITE CASE-RECORD
    CLOSE CASE-FILE
    DISPLAY "The case record has been created successfully."

LogService.
    DISPLAY "Please enter the ID of the client who received this service:"
    ACCEPT CLIENT-ID
    DISPLAY "Please enter the date the service was provided (YYYYMMDD):"
    ACCEPT SERVICE-DATE
    DISPLAY "Please enter the type of service provided:"
    ACCEPT SERVICE-TYPE
    DISPLAY "Please enter a description of the service provided:"
    ACCEPT SERVICE-DESCRIPTION
    DISPLAY "Please enter a unique ID for the service:"
    ACCEPT SERVICE-ID
    OPEN OUTPUT SERVICE-FILE
    WRITE SERVICE-RECORD
    CLOSE SERVICE-FILE
    DISPLAY "The service record has been logged successfully."

GenerateReport.
    OPEN INPUT CLIENT-FILE, CASE-FILE, SERVICE-FILE
    OPEN OUTPUT REPORT-FILE
    READ CLIENT-FILE AT END SET EOF-REACHED TO TRUE
    PERFORM UNTIL EOF-REACHED
        MOVE CLIENT-RECORD TO REPORT-RECORD
        WRITE REPORT-RECORD
        READ CLIENT-FILE AT END SET EOF-REACHED TO TRUE
    END-PERFORM
    CLOSE CLIENT-FILE, CASE-FILE, SERVICE-FILE, REPORT-FILE
    DISPLAY "The report has been generated successfully."

SearchClient.
    DISPLAY "Please enter the ID of the Please enter the ID of the client you wish to search for:"
    
    ACCEPT SEARCH-ID
    OPEN INPUT CLIENT-FILE
    READ CLIENT-FILE AT END SET EOF-REACHED TO TRUE
    PERFORM UNTIL EOF-REACHED OR CLIENT-ID = SEARCH-ID
        IF CLIENT-ID = SEARCH-ID THEN
            DISPLAY "Client Found: " CLIENT-NAME
            DISPLAY "Client Address: " CLIENT-ADDRESS
        ELSE
            READ CLIENT-FILE AT END SET EOF-REACHED TO TRUE
        END-IF
    END-PERFORM
    IF EOF-REACHED THEN
        DISPLAY "Client Not Found."
    CLOSE CLIENT-FILE.



