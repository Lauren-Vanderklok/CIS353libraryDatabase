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
    --apparantly the usual char datatype I've been using 
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
    CONSTRAINT tIC5 CHECK (FeeAmount <=100)
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

--Join involving at least 4 relations
-- the titles and author of every book at the location with BranchID = 3
SELECT L.BranchID, C.ISBN, B.Title, A.Author 
FROM Locations L, CopyOfBook C, Books B, Authors A
WHERE L.BranchID = 3 AND 
    L.BranchID = C.BranchID AND 
    C.ISBN = B.ISBN AND
    B.ISBN = A.ISBN;
    
--Self join
--IDs and Branches of staff members and their mentors if their mentor works in a different branch
SELECT S.StaffID, S.BranchID, M.StaffID, M.BranchID
FROM   Staff S, Staff M
WHERE  M.StaffID = S.MentorID AND 
       S.BranchID != M.BranchID
ORDER BY S.StaffID;

-- Division query, and query using MINUS
-- every patron who has checked out every book by author "Dr. Arch" 
SELECT P.Name, P.PatronID
FROM Patrons P
WHERE NOT EXISTS(
    (SELECT A.ISBN 
    FROM Authors A
    WHERE A.Author = "Dr. Arch")
    MINUS
    (SELECT A.ISBN
    FROM Transactions T, CopyOfBook C, Authors A
    WHERE P.PatronID = T.PatronID AND
        T.Barcode = C.Barcode AND
        C.ISBN = A.ISBN AND
        A.Author = "Dr. Arch"
    )
);

--Query with MAX
--The greatest amount owed by a patron
SELECT MAX(FeeAmount) AS maxFee
FROM Transactions;


--
-- insert/delete/update statements to test the integrity constraints (note: just test the 4 ICs in the project proposal)
-- all of the following should be rejected
-- Test bIC1
INSERT INTO Patrons VALUES (111, 'Dave Ross', '777 Game St');
-- Test cIC1
INSERT INTO Staff VALUES (740, 'Dan Armon', NULL, 4);
-- Test tIC5
INSERT INTO Transactions VALUES (111, 00111, 2016-12-08, 2016-12-22, 2017-01-06, NULL, 120.99);
-- Test tIC2
INSERT INTO Transactions VALUES (111, 01000, 2016-12-08, 2017-01-06, 2017-01-06, NULL, NULL);

COMMIT;
--
SPOOL OFF


