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

INSERT INTO Staff
VALUES(731, 'Alice Brown', 733, 1);
INSERT INTO Staff
VALUES(732, 'Joseph Lydon', NULL, 2);
INSERT INTO Staff
VALUES(733, 'Gabi Caldwell', NULL, 1);
INSERT INTO Staff
VALUES(734, 'Bella Rossi', NULL, 1);
INSERT INTO Staff
VALUES(735, 'Kelsey Carter', NULL, 3);
INSERT INTO Staff
VALUES(736, 'Seth Warfield', NULL, 2);
INSERT INTO Staff
VALUES(737, 'Ashley Reister', 734, 1);
INSERT INTO Staff
VALUES(738, 'Chad Allard', 736, 3);
INSERT INTO Staff
VALUES(739, 'Levi Brand', 732, 2);

INSERT INTO Locations
VALUES(1, 'Woodland', 'Reading Rd');
INSERT INTO Locations
VALUES(2, 'Rivertown', 'Learning Ln');
INSERT INTO Locations
VALUES(3, 'Farmington', 'Punctuation Pl');

INSERT INTO Books
VALUES(0000001, 'SQL For Dummies', 'Textbook');
INSERT INTO Books
VALUES(0000002, 'SQL For Beginners', 'Textbook');
INSERT INTO Books
VALUES(0000003, 'SQL For Students', 'Textbook');
INSERT INTO Books
VALUES(0000004, 'SQL For For Advanced Individuals', 'Professional Development');
INSERT INTO Books
VALUES(0000005, 'SQL For Experts', 'Professional Development');
INSERT INTO Books
VALUES(0000006, 'SQL For World Domination', 'Geopolitical Theory');
INSERT INTO Books
VALUES(9999999, 'What To Do Once You Have Conquered The World Through SQL', 'Geopolitical Theory');

INSERT INTO CopyOfBook
VALUES(00000, '1', 0000002);
INSERT INTO CopyOfBook
VALUES(00001, '1', 0000001);
INSERT INTO CopyOfBook
VALUES(00010, '1', 0000003);
INSERT INTO CopyOfBook
VALUES(00011, '1', 0000004);
INSERT INTO CopyOfBook
VALUES(00100, '2', 0000002);
INSERT INTO CopyOfBook
VALUES(00101, '2', 0000003);
INSERT INTO CopyOfBook
VALUES(00110, '2', 0000005);
INSERT INTO CopyOfBook
VALUES(00111, '2', 0000006);
INSERT INTO CopyOfBook
VALUES(01000, '2', 9999999);
INSERT INTO CopyOfBook
VALUES(01001, '3', 0000001);
INSERT INTO CopyOfBook
VALUES(01010, '3', 0000002);
INSERT INTO CopyOfBook
VALUES(01011, '3', 0000004);
INSERT INTO CopyOfBook
VALUES(01100, '3', 0000006);
INSERT INTO CopyOfBook
VALUES(01101, '3', 9999999);

INSERT INTO Authors
VALUES(0000001,'Paige Turner');
INSERT INTO Authors
VALUES(0000002,'Paige Turner');
INSERT INTO Authors
VALUES(0000002,'Reed Wells');
INSERT INTO Authors
VALUES(0000003,'Paige Turner');
INSERT INTO Authors
VALUES(0000001,'Seamore Butts');
INSERT INTO Authors
VALUES(0000005,'Dr. Arch');
INSERT INTO Authors
VALUES(0000006,'Dr. Arch');
INSERT INTO Authors
VALUES(9999999,'Kim Jong-Un');

INSERT INTO Patrons
VALUES(111, 'Emily Julian', '123 Parkway');
INSERT INTO Patrons
VALUES(222, 'Dani Langdon', '3261 60th Ave');
INSERT INTO Patrons
VALUES(333, 'Max Comwell', '452 West');
INSERT INTO Patrons
VALUES(444, 'Corey Kroll', '987 Sibley');
INSERT INTO Patrons
VALUES(555, 'Norman Gates', '231 Pleasant St');
INSERT INTO Patrons
VALUES(666, 'Alex DeLeon', '55321 Marina Pl');

INSERT INTO Transactions
VALUES(111, 00010, DATE '2008-10-03', DATE '2008-10-17', DATE '2008-10-02', NULL, NULL);
INSERT INTO Transactions
VALUES(222, 00111, DATE '2010-03-21', DATE '2010-04-05', DATE '2010-03-27', DATE '2010-03-27', 10.00);
INSERT INTO Transactions
VALUES(222, 00110, DATE '2012-04-20', DATE '2012-05-04', DATE '2012-06-20', DATE '2012-06-20', 62.00);
INSERT INTO Transactions
VALUES(444, 00001, DATE '2016-12-22', DATE '2016-12-22', DATE '2017-01-06', NULL, NULL);
INSERT INTO Transactions
VALUES(333, 01010, DATE '2020-05-14', DATE '2020-05-28', DATE '2020-06-17', NULL, 28.00);
INSERT INTO Transactions
VALUES(555, 00011, DATE '2020-03-18', DATE '2020-04-01', DATE '2020-04-22', DATE '2020-05-20', 42.00);
INSERT INTO Transactions
VALUES(666, 01101, DATE '2020-02-22', DATE '2020-03-07', NULL, NULL, 100.00);

INSERT INTO Supplier
VALUES(121);
INSERT INTO Supplier
VALUES(122);
INSERT INTO Supplier
VALUES(123);

INSERT INTO Supplies
VALUES(121, 0000004, 4.95);
INSERT INTO Supplies
VALUES(121, 0000003, 7.95);
INSERT INTO Supplies
VALUES(121, 0000002, 25.00);
INSERT INTO Supplies
VALUES(121, 0000002, 22.95);
INSERT INTO Supplies
VALUES(121, 9999999, 299.99);


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

--GROUP BY, HAVING, and ORDER BY query
--BranchID and number of workers for each branch with less than 3 workers
SELECT S.BranchID, COUNT(*)
FROM   Locations L, Staff S
WHERE  S.BranchID = L.BranchID
GROUP BY S.StaffID, S.BranchID
HAVING COUNT(*) < 3
ORDER BY S.BranchID;

--Correlated subquery
-- Find second greatest fee amount
SELECT e1.Name, e1.FeeAmount
FROM Transactions e1
WHERE N-1 = 
    (SELECT COUNT(DISTINCT FeeAmount)
     FROM Transactions e2
    WHERE e2.FeeAmount > e1.FeeAmount)
ORDER BY e1.Name;

--Noncorrelated subquery
--Find patrons who haven't owed any fees
SELECT P.Name, P.PatronID
FROM Patrons P
WHERE P.PatronID NOT IN 
    (SELECT T.PatronID FROM Transactions T
    WHERE T.FeeAmount NOT NULL)
ORDER BY P.PatronID;

--Outer join query
--Name of staff who also are patrons
SELECT Staff.Name
FROM Staff
    FULL OUTER JOIN Patrons ON Staff.Name = Patrons.Name;
    --may need "WHERE"

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


