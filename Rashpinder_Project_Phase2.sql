--Name: Rashpinder Kaur Chahal
--Project Phase 2

CREATE DATABASE db_LibraryManagement;
USE db_LibraryManagement;

CREATE TABLE tbl_publisher (
    publisher_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20)
);

CREATE TABLE tbl_book (
    book_id INT IDENTITY(1,1) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    FOREIGN KEY (publisher_id) REFERENCES tbl_publisher(publisher_id)
);

CREATE TABLE tbl_library_branch (
    branch_id INT IDENTITY(1,1) PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    address VARCHAR(255)
);

CREATE TABLE tbl_borrower (
    card_no INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20)
);

CREATE TABLE tbl_book_authors (
    author_id INT IDENTITY(1,1) PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

CREATE TABLE tbl_book_copies (
    book_id INT,
    branch_id INT,
    no_of_copies INT DEFAULT 0,
    PRIMARY KEY (book_id, branch_id),
    FOREIGN KEY (book_id) REFERENCES tbl_book(book_id),
    FOREIGN KEY (branch_id) REFERENCES tbl_library_branch(branch_id)
);

CREATE TABLE tbl_book_loans (
    loan_id INT IDENTITY(1,1) PRIMARY KEY,
    book_id INT,
    branch_id INT,
    card_no INT,
    date_out DATE,
    due_date DATE,
    date_in DATE,
    FOREIGN KEY (book_id) REFERENCES tbl_book(book_id),
    FOREIGN KEY (branch_id) REFERENCES tbl_library_branch(branch_id),
    FOREIGN KEY (card_no) REFERENCES tbl_borrower(card_no)
);

-- Optional linking table for book authorship (many-to-many)
CREATE TABLE tbl_book_author_link (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES tbl_book(book_id),
    FOREIGN KEY (author_id) REFERENCES tbl_book_authors(author_id)
);

-- Publishers
INSERT INTO tbl_publisher (name, address, phone) VALUES
('Bloomsbury', '50 Bedford Square, London', '020 7631 5600'),
('Pan Books', '20 Vauxhall Bridge Rd, London', '020 7921 8000');

-- Authors
INSERT INTO tbl_book_authors (author_name) VALUES
('J.K. Rowling'), ('Stephen King'), ('J.D. Salinger');

-- Books
INSERT INTO tbl_book (title, publisher_id) VALUES
('Harry Potter and the Sorcerer\', 1),
('The Shining', 2),
('The Catcher in the Rye', 2),
('The Lost Tribe', 1);

-- Link books and authors
INSERT INTO tbl_book_author_link (book_id, author_id) VALUES
(1, 1), -- Harry Potter by J.K. Rowling
(2, 2), -- The Shining by Stephen King
(3, 3), -- The Catcher in the Rye by J.D. Salinger
(4, 2); -- The Lost Tribe by Stephen King (example)

-- Library Branches
INSERT INTO tbl_library_branch (branch_name, address) VALUES
('Central', '123 Main St, New York, NY'),
('Sharpstown', '45 West Side Avenue, New York, NY');

-- Borrowers
INSERT INTO tbl_borrower (name, address, phone) VALUES
('Joe Smith', '101 Elm St, New York, NY', '2125551234'),
('Mary Johnson', '202 Oak St, Boston, MA', '6175555678'),
('Tom Brown', '303 Pine St, New York, NY', '2125559876');

-- Book Copies
INSERT INTO tbl_book_copies (book_id, branch_id, no_of_copies) VALUES
(1, 1, 15),
(1, 2, 5),
(2, 1, 7),
(3, 2, 12),
(4, 1, 8);

-- Book Loans
INSERT INTO tbl_book_loans (book_id, branch_id, card_no, date_out, due_date, date_in) VALUES
(1, 1, 1, '2025-06-01', '2025-06-15', NULL),
(2, 1, 2, '2025-05-20', '2025-06-03', '2025-06-02'),
(3, 2, 3, '2025-06-05', '2025-06-20', NULL);

--Titles of all books published by "Bloomsbury":
SELECT b.title
FROM tbl_book b
JOIN tbl_publisher p ON b.publisher_id = p.publisher_id
WHERE p.name = 'Bloomsbury';

--Borrowers whose phone numbers start with "212"
SELECT name
FROM tbl_borrower
WHERE phone LIKE '212%';

--Titles of books with more than 10 copies available (sum across branches):
SELECT b.title
FROM tbl_book b
JOIN tbl_book_copies bc ON b.book_id = bc.book_id
GROUP BY b.book_id, b.title
HAVING SUM(bc.no_of_copies) > 10;

--Borrowers who have borrowed books from the "Central" branch:
SELECT DISTINCT br.name
FROM tbl_borrower br
JOIN tbl_book_loans bl ON br.card_no = bl.card_no
JOIN tbl_library_branch lb ON bl.branch_id = lb.branch_id
WHERE lb.branch_name = 'Central';

--5. List the titles of books borrowed by borrower 'Joe Smith';
Select book.book_id, book.title 
From tbl_book book
JOIN tbl_book_loans loan ON loan.book_id=book.book_id
JOIN tbl_borrower br ON br.card_no=loan.card_no
WHERE br.name='Joe Smith';

--6. Find the names of publishers for the books authored by 'J.K. Rowling';
SELECT tbl_publisher.name AS Publisher_Name 
FROM tbl_publisher 
Join tbl_book ON tbl_book.publisher_id=tbl_publisher.publisher_id
JOIN tbl_book_author_link ON tbl_book.book_id=tbl_book_author_link.book_id
JOIN tbl_book_authors ON tbl_book_author_link.author_id=tbl_book_authors.author_id
WHERE tbl_book_authors.author_name='J.K. Rowling';

--7. Count the total number of books available in the library.
SELECT count(tbl_book.book_id), tbl_library_branch.branch_name
FROM tbl_book 
JOIN tbl_book_loans ON tbl_book.book_id=tbl_book_loans.book_id
JOIN tbl_library_branch ON tbl_library_branch.branch_id=tbl_book_loans.branch_id
Group by tbl_library_branch.branch_id,tbl_library_branch.branch_name;

--8. Calculate the average number of copies available per book across all branches.
SELECT avg(tbl_book_copies.no_of_copies) AS Copies_Available_Per_Book ,
tbl_library_branch.branch_name,
tbl_book.title
FROM tbl_book JOIN 
tbl_book_copies ON tbl_book.book_id=tbl_book_copies.book_id
JOIN tbl_library_branch ON tbl_book_copies.branch_id=tbl_library_branch.branch_id
Group by tbl_library_branch.branch_id,tbl_library_branch.branch_name,tbl_book.title;

--9. Find the branch with the highest number of books loaned out.
SELECT tbl_library_branch.branch_name, count(tbl_book_loans.loan_id)
FROM tbl_library_branch
JOIN tbl_book_loans ON tbl_library_branch.branch_id=tbl_book_loans.branch_id
Group by tbl_book_loans.branch_id,tbl_library_branch.branch_name;

--10. Insert a new book titled 'The Catcher in the Rye' by 'J.D. Salinger' into the database.


INSERT INTO tbl_book (title)
VALUES ('The Catcher in the Rye');

IF NOT EXISTS (
    SELECT 1 FROM tbl_book WHERE title = 'The Catcher in the Rye'
)
BEGIN
    INSERT INTO tbl_book (title, publisher_id)
    VALUES ('The Catcher in the Rye', 1);
END


--11. Update the address of the 'Sharpstown' library branch to '45 West Side Avenue, New York, NY 10012';
UPDATE tbl_library_branch
SET address = '45 West Side Avenue, New York, NY 10012'
WHERE branch_name = 'Sharpstown';

--12. Remove all books published by 'Pan Books' from the database.
DELETE tbl_book
FROM tbl_book
JOIN tbl_publisher ON tbl_book.publisher_id = tbl_publisher.publisher_id
WHERE tbl_publisher.name = 'Pan Books';

--13. Retrieve the names of borrowers who have borrowed the same book more than once.
SELECT b.name
FROM tbl_borrower AS b
JOIN tbl_book_loans AS l ON b.card_no = l.card_no
GROUP BY b.name, l.book_id
HAVING COUNT(*) > 1;

--14. Find the title of the book with the earliest due date.
SELECT b.title
FROM tbl_book AS b
JOIN tbl_book_loans AS l ON b.book_id = l.book_id
WHERE l.due_date = (
    SELECT MIN(due_date)
    FROM tbl_book_loans
);

--15. List the names of borrowers who have borrowed books authored by both 'Stephen King' and 'J.K.Rowling'
SELECT b1.name
FROM tbl_borrower AS b1
JOIN tbl_book_loans AS l1 ON b1.card_no = l1.card_no
JOIN tbl_book_author_link AS a1 ON l1.book_id = a1.book_id
JOIN tbl_book_authors AS a ON  a.author_id=a1.author_id
WHERE a.author_name IN ('Stephen King', 'J.K. Rowling')
GROUP BY b1.name
HAVING COUNT(DISTINCT a.author_name) = 2;

--16. Find the names of borrowers who have borrowed books published by 'Bloomsbury'
SELECT DISTINCT b.name
FROM tbl_borrower AS b
JOIN tbl_book_loans AS l ON b.card_no = l.card_no
JOIN tbl_book AS bk ON l.book_id = bk.book_id
JOIN tbl_publisher AS p ON bk.publisher_id = p.publisher_id
WHERE p.name = 'Bloomsbury';

--17. Retrieve the titles of books borrowed by borrowers located in New York.
SELECT DISTINCT bk.title
FROM tbl_book AS bk
JOIN tbl_book_loans AS l ON bk.book_id = l.book_id
JOIN tbl_borrower AS b ON l.card_no = b.card_no
WHERE b.address LIKE '%New York%';

--18. Calculate the average number of books borrowed per borrower.
SELECT AVG(book_count) AS avg_books_per_borrower
FROM (
    SELECT card_no, COUNT(*) AS book_count
    FROM tbl_book_loans
    GROUP BY card_no
) AS borrower_loans;

--19. Find the branch with the highest average number of books borrowed per borrower.
SELECT TOP 1
    lb.branch_name,
    COUNT(bl.loan_id) * 1.0 / COUNT(DISTINCT bl.card_no) AS avg_books_per_borrower
FROM 
    tbl_book_loans bl
JOIN 
    tbl_library_branch lb ON bl.branch_id = lb.branch_id
GROUP BY 
    lb.branch_name
ORDER BY 
    avg_books_per_borrower DESC;


--20. Rank library branches based on the total number of books borrowed, without grouping
SELECT 
    sub.branch_id,
    br.branch_name,
    sub.total_books_borrowed,
    RANK() OVER (ORDER BY sub.total_books_borrowed DESC) AS rank
FROM (
    SELECT 
        branch_id,
        COUNT(book_id) AS total_books_borrowed
    FROM tbl_book_loans
    GROUP BY branch_id
) sub
JOIN tbl_library_branch br ON sub.branch_id = br.branch_id;

--21. Calculate the percentage of books borrowed from each branch relative to the total number of books borrowed across all branches.
SELECT 
    lb.branch_name,
    COUNT(bl.loan_id) AS total_borrowed,
    ROUND(
        COUNT(bl.loan_id) * 100.0 / 
        (SELECT COUNT(*) FROM tbl_book_loans), 2
    ) AS percentage_borrowed
FROM 
    tbl_book_loans bl
JOIN 
    tbl_library_branch lb ON bl.branch_id = lb.branch_id
GROUP BY 
    lb.branch_name;

--22. Borrowers who borrowed both Stephen King and J.K. Rowling books from the same branch
SELECT DISTINCT b1.card_no, br.name
FROM tbl_book_loans b1
JOIN tbl_book_author_link l1 ON b1.book_id = l1.book_id
JOIN tbl_book_authors a1 ON l1.author_id = a1.author_id
JOIN tbl_book_loans b2 ON b1.card_no = b2.card_no AND b1.branch_id = b2.branch_id
JOIN tbl_book_author_link l2 ON b2.book_id = l2.book_id
JOIN tbl_book_authors a2 ON l2.author_id = a2.author_id
JOIN tbl_borrower br ON b1.card_no = br.card_no
WHERE a1.author_name = 'Stephen King' AND a2.author_name = 'J.K. Rowling';


--23. Borrowers who borrowed from New York branches and have >5 books checked out
SELECT br.card_no, br.name
FROM tbl_borrower br
JOIN tbl_book_loans bl ON br.card_no = bl.card_no
JOIN tbl_library_branch lb ON bl.branch_id = lb.branch_id
WHERE lb.address LIKE '%New York%'
GROUP BY br.card_no, br.name
HAVING COUNT(*) > 5;

--24. Copies of "The Lost Tribe" in "Sharpstown"
SELECT bc.no_of_copies
FROM tbl_book_copies bc
JOIN tbl_book b ON bc.book_id = b.book_id
JOIN tbl_library_branch lb ON bc.branch_id = lb.branch_id
WHERE b.title = 'The Lost Tribe' AND lb.branch_name = 'Sharpstown';

--25. Copies of "The Lost Tribe" in each branch
SELECT lb.branch_name, bc.no_of_copies
FROM tbl_book_copies bc
JOIN tbl_book b ON bc.book_id = b.book_id
JOIN tbl_library_branch lb ON bc.branch_id = lb.branch_id
WHERE b.title = 'The Lost Tribe';

--26. Borrowers with no books checked out
SELECT br.name
FROM tbl_borrower br
LEFT JOIN tbl_book_loans bl ON br.card_no = bl.card_no
WHERE bl.loan_id IS NULL;

--27. Books due today from Sharpstown
SELECT b.title, br.name, br.address
FROM tbl_book_loans bl
JOIN tbl_book b ON bl.book_id = b.book_id
JOIN tbl_borrower br ON bl.card_no = br.card_no
JOIN tbl_library_branch lb ON bl.branch_id = lb.branch_id
WHERE lb.branch_name = 'Sharpstown' AND bl.due_date = CAST(GETDATE() AS DATE);

--28. Total books loaned from each branch
SELECT lb.branch_name, COUNT(bl.loan_id) AS total_loans
FROM tbl_book_loans bl
JOIN tbl_library_branch lb ON bl.branch_id = lb.branch_id
GROUP BY lb.branch_name;

