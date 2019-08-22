INSERT INTO users (name, email, password) VALUES
('Leeroy Jenkins', 'ljenkins@gmail.com', '$2a$10$FB/BOAVhpuLvpOREQVmvmezD4ED/.JBIDRh70tGevYzYzQgFId2u.'),
('Vincent Vega', 'vvvega@gmail.com', '$2a$10$FB/BOAVhpuLvpOREQVmvmezD4ED/.JBIDRh70tGevYzYzQgFId2u.'),
('James Tiberius Kirk', 'captain@gmail.com', '$2a$10$FB/BOAVhpuLvpOREQVmvmezD4ED/.JBIDRh70tGevYzYzQgFId2u.');

INSERT INTO properties (
  owner_id,
  title, 
  description, 
  thumbnail_photo_url, 
  cover_photo_url,
  cost_per_night,
  parking_spaces,
  number_of_bathrooms,
  number_of_bedrooms,
  country,
  street,
  city,
  province,
  post_code  
) 
VALUES 
(1, 'Speed lamp', 'description', 'http://fillmurray.com/50/50', 'http://fillmurray.com/800/200', 12345, 2, 2, 3, 'Canada', '123 Main St.', 'Springfield', 'Alberta', '12345'),
(2, 'Blank corner', 'description', 'http://fillmurray.com/50/50', 'http://fillmurray.com/800/200', 23456, 1, 3, 2, 'Canada', '234 Main St.', 'Springfield', 'Alberta', '23456'),
(3, 'Habit mix', 'description', 'http://fillmurray.com/50/50', 'http://fillmurray.com/800/200', 14563, 0, 4, 2, 'Canada', '345 Main St.', 'Springfield', 'Alberta', '34567');

INSERT INTO rates (
  start_date,
  end_date,
  cost_per_night,
  property_id
)
VALUES 
('1963-11-04', '1995-12-12', 12345, 1),
('1937-12-02', '2003-1-8', 23456, 2),
('2012-12-02', '2013-1-8', 3456, 3);

INSERT INTO reservations (
  start_date,
  end_date,
  property_id,
  guest_id
)
VALUES
('1963-11-04', '1995-12-12', 3, 1),
('1937-12-02', '2003-1-8', 2, 2),
('2012-12-02', '2013-1-8', 1, 3);

INSERT INTO property_reviews (
  guest_id,
  property_id,
  reservation_id,
  rating,
  message
)
VALUES
(1, 2, 3, 5, 'message'),
(3, 2, 1, 4, 'message'),
(1, 3, 2, 3, 'message');

INSERT INTO guest_reviews (
  guest_id,
  owner_id,
  reservation_id,
  rating,
  message
) 
VALUES
(1, 2, 3, 5, 'message'),
(3, 2, 1, 4, 'message'),
(1, 3, 2, 3, 'message');