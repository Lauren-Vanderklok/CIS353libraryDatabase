SPOOL project.txt
SET ECHO ON

/*
CIS 353-Database Design Project
Tim Bomers
Lauren Freeman
Jacob Lakies
Lauren Vanderklok (Coordinator)
*/

CREATE TABLE Books(
    ISBN INTEGER,
    title VARCHAR2(200), 
    genre VARCHAR2(100),
    --appearantly the ususal char datatype ive been using 
    --MUST have that num of chars and this datatype does not have this problem

    CONSTRAINT bIC1 PRIMARY KEY (ISBN)
);

CREATE TABLE Locations(
    BranchID INTEGER PRIMARY KEY,
    Name CHAR(100),
    Address CHAR(500)
);

CREATE TABLE CopyOfBook(
    Barcode INTEGER PRIMARY KEY,
    BranchID INTEGER,
    ISBN INTEGER,

    CONSTRAINT cIC1 FOREIGN KEY (ISBN) REFERENCES Books (ISBN)
        ON DELETE CASCADE,
    CONSTRAINT cIC2 FOREIGN KEY (BranchID) REFERENCES Locations (BranchID)
        ON DELETE SET NULL
);

--isnt working rn
CREATE TABLE Staff(
    StaffID INTEGER,
    Name CHAR(100),
    MentorID INTEGER UNIQUE,
    BranchID INTEGER,

    CONSTRAINT sIC1 PRIMARY KEY (StaffID),

    CONSTRAINT sIC2 FOREIGN KEY (MentorID) REFERENCES Staff (MentorID)
        ON DELETE SET NULL,
    
    CONSTRAINT sIC3 FOREIGN KEY (BranchID) REFERENCES Locations (BranchID)
        ON DELETE SET NULL
);

CREATE TABLE Authors(
    ISBN INTEGER,
    Author CHAR(100),

    CONSTRAINT aIC1 PRIMARY KEY (ISBN, Author),
    CONSTRAINT aIC2 FOREIGN KEY (ISBN) REFERENCES Books (ISBN)
        ON DELETE CASCADE
);

CREATE TABLE Patrons(
    PatronID INTEGER,
    Name CHAR(100),
    Address CHAR(500),

    CONSTRAINT pIC1 PRIMARY KEY (PatronID)
);

CREATE TABLE Transactions(
    PatronID INTEGER,
    Barcode INTEGER,
    LoanDate DATE,
    DueDate DATE,
    ReturnDate DATE,
    DatePaid DATE,
    FeeAmount DECIMAL(6,2),

    CONSTRAINT tIC1 PRIMARY KEY (PatronID, Barcode, LoanDate),
    CONSTRAINT tIC2 CHECK (DueDate = LoanDate+14),
    CONSTRAINT tIC3 FOREIGN KEY (PatronID) REFERENCES Patrons (PatronID)
        ON DELETE CASCADE,
    CONSTRAINT tIC4 FOREIGN KEY (Barcode) REFERENCES CopyOfBook (Barcode)
        ON DELETE SET NULL
);

CREATE TABLE Supplier(
    SupplierID INTEGER PRIMARY KEY
);

CREATE TABLE Supplies(
    SupplierID INTEGER,
    ISBN INTEGER,
    Price DECIMAL(6,2),

    CONSTRAINT suppliesIC1 PRIMARY KEY (SupplierID, ISBN),
    CONSTRAINT suppliesIC2 FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID)
        ON DELETE CASCADE,
    CONSTRAINT suppliesIC3 FOREIGN KEY (ISBN) REFERENCES Books (ISBN)
        ON DELETE CASCADE
);

--
SET FEEDBACK OFF

--insert statements to fill tables ( not the ones to test the integrity constraints)

SET FEEDBACK ON
COMMIT;
--
SELECT * FROM Staff;
SELECT * FROM Locations;
SELECT * FROM Books;
SELECT * FROM CopyOfBook;
SELECT * FROM Authors;
SELECT * FROM Patrons;
SELECT * FROM Transactions;
SELECT * FROM Supplier;
SELECT * FROM Supplies;
--
-- queries, on of each type listed in project assignment doc



--
-- insert/delete/update statements to test the integrity constraints (note: you just have to test the 4 ICs that were in the project proposal)
COMMIT;
--
SPOOL OFF


