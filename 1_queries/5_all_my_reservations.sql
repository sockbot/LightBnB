SELECT DISTINCT
  reservations.*,
  properties.*,
  avg(rating)
FROM reservations
JOIN users ON users.id = guest_id
JOIN properties ON properties.id = property_id
JOIN property_reviews ON properties.id = property_reviews.property_id
WHERE users.id = 1 AND end_date < now()::date
GROUP BY reservations.id, properties.id
ORDER BY start_date DESC
LIMIT 10;