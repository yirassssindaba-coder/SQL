DROP DATABASE IF EXISTS salon;
CREATE DATABASE salon;

\c salon

DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS services;

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(20) NOT NULL UNIQUE,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR(50) NOT NULL
);

INSERT INTO services(service_id, name) VALUES
(1, 'cut'),
(2, 'color'),
(3, 'perm');
