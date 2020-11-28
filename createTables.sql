CREATE TABLE Books(
    ISBN integer primary key,
    title char(200),
    genre char(100)
)

CREATE TABLE Locations(
    BranchID INTEGER PRIMARY KEY,
    Name CHAR(100),
    Address CHAR(500)
)

CREATE TABLE CopyOfBook(
    Barcode INTEGER PRIMARY KEY,
    BranchID INTEGER,
    ISBN INTEGER,

    CONSTRAINT cIC1 FOREIGN KEY (ISBN) REFERENCES Books (ISBN)
        ON DELETE CASCADE,
    CONSTRAINT cIC2 FOREIGN KEY (BranchID) REFERENCES Locations (BranchID)
        ON DELETE SET NULL
)

CREATE TABLE Staff(
    StaffID INTEGER PRIMARY KEY,
    Name CHAR(100),
    MentorID INTEGER,
    BranchID INTEGER,

    CONSTRAINT sIC1 FOREIGN KEY (MentorID) REFERENCES Staff (MentorID)
        ON DELETE SET NULL,
    CONSTRAINT sIC2 FOREIGN KEY (BranchID) REFERENCES Locations (BranchID)
        ON DELETE SET NULL
)

CREATE TABLE Author(
    ISBN INTEGER,
    Author CHAR(100),

    CONSTRAINT aIC1 PRIMARY KEY (ISBN, Author)
)

CREATE TABLE Patrons(
    PatronID INTEGER PRIMARY KEY,
    Name CHAR(100),
    Address CHAR(500)
)

CREATE TABLE OverDueFees(
    PatronID INTEGER,
    Barcode INTEGER,
    LoanDate CHAR(10),
    DueDate CHAR(10),
    ReturnDate CHAR(10),
    DatePaid CHAR(10),
    FeeAmount FLOAT,

    CONSTRAINT PRIMARY KEY (PatronID, Barcode, LoanDate)
)
