require('dotenv').config();
const properties = require('./json/properties.json');
const users = require('./json/users.json');
const { Pool } = require('pg');
const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME
});

/// Users

/**
 * Get a single user from the database given their email.
 * @param {String} email The email of the user.
 * @return {Promise<{}>} A promise to the user.
 */
const getUserWithEmail = function(email) {
  return pool.query(`
  SELECT *
  FROM users
  WHERE email = $1
  `, [email])
  .then(res => {
    if (res.rows.length == 0) { 
      return null;
    } else {
      return res.rows[0];
    }
  })
}
exports.getUserWithEmail = getUserWithEmail;

/**
 * Get a single user from the database given their id.
 * @param {string} id The id of the user.
 * @return {Promise<{}>} A promise to the user.
 */
const getUserWithId = function(id) {
  return pool.query(`
  SELECT *
  FROM users
  WHERE id = $1
  `, [id])
  .then(res => {
    if (res.rows.length == 0) { 
      return null;
    } else {
      return res.rows[0];
    }
  })
}
exports.getUserWithId = getUserWithId;


/**
 * Add a new user to the database.
 * @param {{name: string, password: string, email: string}} user
 * @return {Promise<{}>} A promise to the user.
 */
const addUser = function(user) {
  return pool.query(`
  INSERT INTO users (name, email, password)
  VALUES ($1, $2, $3)
  RETURNING *;
  `, [user.name, user.email, user.password])
  .then(res => {
    return res.rows[0];
  })
};
exports.addUser = addUser;

/// Reservations

/**
 * Get all reservations for a single user.
 * @param {string} guest_id The id of the user.
 * @return {Promise<[{}]>} A promise to the reservations.
 */
const getAllReservations = function(guest_id, limit = 10) {
  if (limit > 10) { limit = 10 };
  return pool.query(`
  SELECT DISTINCT
  reservations.*,
  properties.*,
  avg(rating)
  FROM reservations
  JOIN users ON users.id = guest_id
  JOIN properties ON properties.id = property_id
  JOIN property_reviews ON properties.id = property_reviews.property_id
  WHERE users.id = $1 AND end_date < now()::date
  GROUP BY reservations.id, properties.id
  ORDER BY start_date DESC
  LIMIT $2;
  `, [guest_id, limit])
  .then(res => {
    return res.rows;
  }) 
}
exports.getAllReservations = getAllReservations;

/// Properties

/**
 * Get all properties.
 * @param {{}} options An object containing query options.
 * @param {*} limit The number of results to return.
 * @return {Promise<[{}]>}  A promise to the properties.
 */
const getAllProperties = function(options, limit = 10) {
  const queryParams = [];

  let queryString = `
  SELECT
  properties.id,
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
  post_code,
  active,
  avg(property_reviews.rating) AS average_rating
  FROM properties
  JOIN property_reviews ON property_id = properties.id
  `;
  
  if (options.minimum_price_per_night) {
    queryParams.push(options.minimum_price_per_night * 100) // turn dollars into cents (prices stored in db in cents)
  } else {
    queryParams.push(0);
  }
  queryString += `WHERE cost_per_night >= $${queryParams.length} `
  
  if (options.maximum_price_per_night) {
    if (queryParams.length > 0) {
      queryString += 'AND ';
    }
    queryParams.push(options.maximum_price_per_night * 100); // turn dollars into cents (prices stored in db in cents)
    queryString += `cost_per_night <= $${queryParams.length} `;
  }
  
  if (options.owner_id) {
    if (queryParams.length > 0) {
      queryString += 'AND ';
    }
    queryParams.push(options.owner_id)
    queryString += `owner_id = $${queryParams.length}`
  }
    
  if (options.city) {
    if (queryParams.length > 0) {
      queryString += 'AND ';
    }
    queryParams.push(`%${options.city}%`);
    queryString += `city ILIKE $${queryParams.length} `;
  }

  queryString += 'GROUP BY properties.id ';

  if (options.minimum_rating) {
    queryParams.push(options.minimum_rating);
    queryString += `HAVING avg(rating) >= $${queryParams.length} `;
  }
  queryParams.push(limit);
  queryString += `
  ORDER BY cost_per_night
  LIMIT $${queryParams.length};
  `
  return pool.query(queryString, queryParams)
  .then(res => {
    return res.rows;
  }).catch(err => console.error('getAllProperties Query Error:', err.stack));
}
exports.getAllProperties = getAllProperties;


/**
 * Add a property to the database
 * @param {{}} property An object containing all of the property details.
 * @return {Promise<{}>} A promise to the property.
 */
const addProperty = function(property) {
  const propertyId = Object.keys(properties).length + 1;
  property.id = propertyId;
  properties[propertyId] = property;
  return Promise.resolve(property);
}
exports.addProperty = addProperty;
