# This COBOL program is for a case management system

# Identification Division
# Program name is declared here
IDENTIFICATION DIVISION.
PROGRAM-ID. CaseManagementSystem.

# Data Division
# All the variables used in this program are declared here
DATA DIVISION.
WORKING-STORAGE SECTION.
01 Choice PIC 9.
01 ClientName PIC X(50).
01 ClientAddress PIC X(100).
01 CaseWorkerName PIC X(50).
01 ServiceDate PIC 9(8).
01 ServiceType PIC X(20).
01 ServiceDescription PIC X(100).
01 ClientID PIC 9(5).
01 CaseID PIC 9(5).
01 ServiceID PIC 9(5).
01 ClientFile STATUS IS INITIAL "CLIENTS.DAT".
01 CaseFile STATUS IS INITIAL "CASES.DAT".
01 ServiceFile STATUS IS INITIAL "SERVICES.DAT".
01 ReportFile STATUS IS INITIAL "REPORT.TXT".

# Procedure Division
# The main logic of the program starts here
PROCEDURE DIVISION.
StartProgram.
    # The main menu is displayed until the user chooses to exit (Choice 6)
    PERFORM DisplayMainMenu UNTIL Choice = 6
    DISPLAY "Goodbye!"
    STOP RUN.

# This procedure displays the main menu options
DisplayMainMenu.
    DISPLAY "-------------------------"
    DISPLAY "Case Management System"
    DISPLAY "-------------------------"
    DISPLAY "1. Create Client"
    DISPLAY "2. Create Case"
    DISPLAY "3. Log Service"
    DISPLAY "4. Generate Report"
    DISPLAY "5. Search Client"
    DISPLAY "6. Exit"
    DISPLAY "-------------------------"
    DISPLAY "Enter your choice (1-6):"
    ACCEPT Choice
    # Depending on the user's choice, the respective procedure is performed
    PERFORM ProcessChoice.

# This procedure performs the action based on the user's choice
ProcessChoice.
    EVALUATE Choice
        WHEN 1 PERFORM CreateClient
        WHEN 2 PERFORM CreateCase
        WHEN 3 PERFORM LogService
        WHEN 4 PERFORM GenerateReport
        WHEN 5 PERFORM SearchClient
        WHEN OTHER
            DISPLAY "Invalid choice."
            PERFORM DisplayMainMenu
    END-EVALUATE.

# This procedure creates a new client and writes it to the client file
CreateClient.
    DISPLAY "Enter Client Name:"
    ACCEPT ClientName
    DISPLAY "Enter Client Address:"
    ACCEPT ClientAddress
    DISPLAY "Enter Client ID:"
    ACCEPT ClientID
    WRITE ClientFile FROM ClientName ClientAddress ClientID
    DISPLAY "Client created successfully."

# This procedure creates a new case and writes it to the case file
CreateCase.
    DISPLAY "Enter Client ID:"
    ACCEPT ClientID
    DISPLAY "Enter Case Worker Name:"
    ACCEPT CaseWorkerName
    DISPLAY "Enter Case ID:"
    ACCEPT CaseID
    WRITE CaseFile FROM ClientID CaseWorkerName CaseID
    DISPLAY "Case created successfully."

# This procedure logs a service and writes it to the service file
LogService.
    DISPLAY "Enter Client ID:"
    ACCEPT ClientID
    DISPLAY "Enter Service Date (YYYYMMDD):"
    ACCEPT ServiceDate
    DISPLAY "Enter Service Type:"
    ACCEPT ServiceType
    DISPLAY "Enter Service Description:"
    ACCEPT ServiceDescription
    DISPLAY "Enter Service ID:"
    ACCEPT ServiceID
    WRITE ServiceFile FROM ClientID ServiceDate ServiceType ServiceDescription ServiceID
    DISPLAY "Service logged successfully."

# This procedure generates a report by reading from the client, case, and service files
GenerateReport.
    OPEN INPUT ClientFile, CaseFile, ServiceFile
    OPEN OUTPUT ReportFile
    PERFORM UNTIL EOF ClientFile
        READ ClientFile
        READ CaseFile
        READ ServiceFile
        DISPLAY "Client: " ClientFile
        DISPLAY "Client Address: " ClientFile
        DISPLAY "Case Worker: " CaseFile
        DISPLAY "Service Date: " ServiceFile
        DISPLAY "Service Type: " ServiceFile
        DISPLAY "Service Description: " ServiceFile
        WRITE ReportFile FROM ClientFile, CaseFile, ServiceFile
    END-PERFORM
    CLOSE ClientFile, CaseFile, ServiceFile, ReportFile
    DISPLAY "Report generated successfully."

# This procedure searches for a client in the client file
SearchClient.
    DISPLAY "Enter Client ID:"
    ACCEPT ClientID
    SEARCH ClientFile WITH KEY = ClientID
    IF FOUND THEN
        DISPLAY "Client Found: " ClientFile
        DISPLAY "Client Address: " ClientFile
    ELSE
        DISPLAY "Client Not Found."
    END-IF.


