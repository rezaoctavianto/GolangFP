DROP TABLE IF EXISTS authors;
CREATE TABLE authors (
  id INT AUTO_INCREMENT NOT NULL,
  name VARCHAR(128) NOT NULL,
  date_of_birth VARCHAR(128) NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
);

INSERT INTO authors (name, date_of_birth) VALUES
('Harper Lee', '1926-04-28'),
('George Orwell', '1903-06-25'),
('F. Scott Fitzgerald', '1896-09-24'),
('Jane Austen', '1775-12-16'),
('J.D. Salinger', '1919-01-01');

DROP TABLE IF EXISTS books;
CREATE TABLE books (
  id INT AUTO_INCREMENT NOT NULL,
  title VARCHAR(128) NOT NULL,
  author_id INT NOT NULL,
  genre VARCHAR(128),
  description TEXT,
  release_date VARCHAR(128) NOT NULL,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (author_id) REFERENCES authors(id) ON DELETE CASCADE
);

INSERT INTO books (title, author_id, genre, description, release_date) VALUES
('Harry Potter and the Chamber of Secrets', 1, 'Fantasy', 'Harry returns to Hogwarts and faces the Chamber of Secrets.', '1998-07-02'),
('Animal Farm', 2, 'Political Satire', 'A tale of farm animals rebelling against their human owner.', '1945-08-17'),
('Go Set a Watchman', 3, 'Fiction', 'A sequel to To Kill a Mockingbird, set in the 1950s.', '2015-07-14'),
('The Great Gatsby', 4, 'Classic', 'A critique of the American Dream set in the Jazz Age.', '1925-04-10'),
('Pride and Prejudice', 5, 'Romance', 'A story of love and social standing in 19th-century England.', '1813-01-28');


