DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS merchants;

CREATE TABLE merchants (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE transactions (
  id SERIAL PRIMARY KEY,
  amount INT,
  a_date DATE NOT NULL DEFAULT CURRENT_DATE,
  merchant_id INT REFERENCES merchants(id) ON DELETE CASCADE
);

CREATE TABLE tags (
  id SERIAL,
  type VARCHAR(255),
  transaction_id INT REFERENCES transactions(id) ON DELETE CASCADE
);
