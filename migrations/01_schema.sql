DROP TABLE IF EXISTS users, properties, rates, reservations, property_reviews, guest_reviews;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL
);

CREATE TABLE properties (
  id SERIAL PRIMARY KEY,
  owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  title VARCHAR(255),
  description VARCHAR(255),
  thumbnail_photo_url VARCHAR(1023),
  cover_photo_url VARCHAR(1023),
  street VARCHAR(255),
  parking_spaces SMALLINT,
  number_of_bathrooms SMALLINT,
  number_of_bedrooms SMALLINT,
  country VARCHAR(255),
  city VARCHAR(255),
  province VARCHAR(255),
  post_code VARCHAR(6),
  active BOOLEAN DEFAULT true
);

CREATE TABLE rates (
  id SERIAL PRIMARY KEY,
  start_date DATE,
  end_date DATE,
  cost_per_night INTEGER,
  property_id INTEGER REFERENCES properties(id) ON DELETE CASCADE
);

CREATE TABLE reservations (
  id SERIAL PRIMARY KEY,
  start_date DATE,
  end_date DATE,
  property_id INTEGER REFERENCES properties(id) ON DELETE CASCADE
);

CREATE TABLE property_reviews (
  id SERIAL PRIMARY KEY,
  guest_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  reservation_id INTEGER REFERENCES reservations(id) ON DELETE CASCADE,
  property_id INTEGER REFERENCES properties(id) ON DELETE CASCADE,
  rating SMALLINT,
  message TEXT
);

CREATE TABLE guest_reviews (
  id SERIAL PRIMARY KEY,
  guest_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
  reservation_id INTEGER REFERENCES reservations(id) ON DELETE CASCADE,
  rating SMALLINT,
  message TEXT 
);