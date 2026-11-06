CREATE DATABASE LibraryManagementDB;

CREATE TABLE Authors
(
    author_id INT PRIMARY KEY IDENTITY(1,1),
    author_name VARCHAR(100) NOT NULL
);

CREATE TABLE Categories
(
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE Books
(
    book_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(150) NOT NULL,
    author_id INT,
    category_id INT,
    publisher VARCHAR(100),
    publication_year INT,
    isbn VARCHAR(20) UNIQUE,
    language VARCHAR(30),
    page_count INT,
    price DECIMAL(10,2),
    shelf_number VARCHAR(20),
    available_copies INT,
    total_copies INT,
    rating DECIMAL(3,2),
    book_status VARCHAR(30),

    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);



CREATE TABLE Borrowings
(
    borrowing_id INT PRIMARY KEY IDENTITY(1,1),
    book_id INT,
    borrower_name VARCHAR(100),
    borrow_date DATE,
    return_date DATE,
    borrowing_status VARCHAR(30),

    FOREIGN KEY (book_id)
    REFERENCES Books(book_id)
);


INSERT INTO Authors (author_name)
VALUES
('Chetan Bhagat'),
('J.K. Rowling'),
('George Orwell'),
('R.K. Narayan'),
('Paulo Coelho'),
('Ruskin Bond'),
('Agatha Christie'),
('Stephen King'),
('William Shakespeare'),
('Dan Brown');


INSERT INTO Categories (category_name)
VALUES
('Fiction'),
('Science'),
('Technology'),
('History'),
('Fantasy'),
('Mystery'),
('Romance'),
('Biography'),
('Horror'),
('Education');


;WITH Numbers AS
(
    SELECT TOP 500
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO Books
(
    title, author_id, category_id, publisher,
    publication_year, isbn, language, page_count,
    price, shelf_number, available_copies,
    total_copies, rating, book_status
)
SELECT
    CONCAT('Book Title ', n),
    ((n - 1) % 10) + 1,
    ((n - 1) % 10) + 1,
    CONCAT('Publisher ', (n % 10) + 1),
    2000 + (n % 25),
    CONCAT('ISBN', RIGHT('000000' + CAST(n AS VARCHAR(6)), 6)),
    CASE WHEN n % 2 = 0 THEN 'English' ELSE 'Hindi' END,
    100 + (n % 500),
    100 + (n * 17 % 900),
    CONCAT('S', (n % 20) + 1),
    n % 10,
    5 + (n % 10),
    CAST(3 + (n % 20) / 10.0 AS DECIMAL(3,2)),
    CASE WHEN n % 4 = 0 THEN 'Unavailable'
         ELSE 'Available' END
FROM Numbers;



;WITH Numbers AS
(
    SELECT TOP 1000
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects a
    CROSS JOIN sys.all_objects b
)
INSERT INTO Borrowings
(
    book_id,
    borrower_name,
    borrow_date,
    return_date,
    borrowing_status
)
SELECT
    ((n - 1) % 500) + 1,

    CONCAT('Borrower ', n),

    DATEADD(DAY, -(n % 700), CAST(GETDATE() AS DATE)),

    CASE
        WHEN n % 3 = 0 THEN NULL
        ELSE DATEADD(DAY, -(n % 700) + 14, CAST(GETDATE() AS DATE))
    END,

    CASE
        WHEN n % 3 = 0 THEN 'Borrowed'
        ELSE 'Returned'
    END

FROM Numbers;



SELECT COUNT(*) AS TotalAuthors FROM Authors;

SELECT COUNT(*) AS TotalCategories FROM Categories;

SELECT COUNT(*) AS TotalBooks FROM Books;

SELECT COUNT(*) AS TotalBorrowings FROM Borrowings;




Q1) SELECT *
FROM Books;

Q2) SELECT *
FROM Books
WHERE publication_year > 2015;

Q3) SELECT *
FROM Books
ORDER BY price DESC;

Q4) SELECT
    c.category_name,
    COUNT(b.book_id) AS TotalBooks
FROM Categories c
LEFT JOIN Books b
    ON c.category_id = b.category_id
GROUP BY c.category_name;

Q5) SELECT AVG(price) AS AverageBookPrice
FROM Books;

Q6) SELECT TOP 10
    title,
    rating
FROM Books
ORDER BY rating DESC;

Q7) 


Q8) SELECT
    b.title,
    a.author_name,
    c.category_name,
    b.price
FROM Books b
INNER JOIN Authors a
    ON b.author_id = a.author_id
INNER JOIN Categories c
    ON b.category_id = c.category_id;


Q9) SELECT
    c.category_name,
    COUNT(b.book_id) AS TotalBooks
FROM Categories c
INNER JOIN Books b
    ON c.category_id = b.category_id
GROUP BY c.category_name
HAVING COUNT(b.book_id) > 30;


Q10) SELECT
    b.title,
    COUNT(br.borrowing_id) AS TimesBorrowed
FROM Books b
INNER JOIN Borrowings br
    ON b.book_id = br.book_id
GROUP BY b.title
ORDER BY TimesBorrowed DESC;