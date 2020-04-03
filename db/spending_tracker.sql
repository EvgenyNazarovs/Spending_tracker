DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS merchants;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS users;

CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  type VARCHAR(255)
);

CREATE TABLE merchants (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  monthly_limit INT
)

CREATE TABLE transactions (
  id SERIAL,
  amount INT,
  date_time TIMESTAMP,
  user_id INT REFERENCES users(id) ON DELETE CASCADE,
  merchant_id INT REFERENCES merchants(id) ON DELETE CASCADE,
  tag_id INT REFERENCES tags(id) ON DELETE CASCADE
);
