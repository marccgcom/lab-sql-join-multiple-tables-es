use sakila;


# 1. Escribe una consulta para mostrar para cada tienda su ID de tienda, ciudad y país.
SELECT 
	store.store_id,
    city.city,
    country.country
FROM
	store
LEFT JOIN address ON store.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id;

# alternativa
SELECT 
	store.store_id,
    city.city,
    country.country
FROM
	store, address, city, country
WHERE
	store.address_id = address.address_id
    AND
    address.city_id = city.city_id
    AND
    city.country_id = country.country_id;

# 2. Escribe una consulta para mostrar cuánto negocio, en dólares, trajo cada tienda.
SELECT
    store.store_id,
    SUM(payment.amount) AS total_revenue
FROM
    payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN store ON inventory.store_id = store.store_id
GROUP BY store.store_id
ORDER BY total_revenue DESC;

# 3. Consulta para obtener el tiempo de ejecución promedio de las películas por categoría
SELECT
    category.name AS category,
    AVG(film.length) AS average_length
FROM
    film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY average_length DESC;

# 4. Consulta para obtener el tiempo de ejecución promedio de las películas por categoría
SELECT
    category.name AS category,
    MAX(film.length) AS longest_film_length
FROM
    film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY longest_film_length DESC;

# 5. Consulta para mostrar las películas más alquiladas en orden descendente
SELECT
    film.title,
    COUNT(rental.rental_id) AS rental_count
FROM
    rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY rental_count DESC;

# 6. Consulta para enumerar los cinco principales géneros en ingresos brutos en orden descendente
SELECT
    category.name AS genre,
    SUM(payment.amount) AS total_revenue
FROM
    payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name
ORDER BY total_revenue DESC
LIMIT 5;

# 7. Consulta para verificar si "Academy Dinosaur" está disponible para alquilar en la Tienda 1
SELECT
    inventory.inventory_id,
    film.title,
    store.store_id,
    IF(rental.return_date IS NULL OR rental.return_date < NOW(), 'Available', 'Not Available') AS availability
FROM
    inventory
JOIN film ON inventory.film_id = film.film_id
JOIN store ON inventory.store_id = store.store_id
LEFT JOIN rental ON inventory.inventory_id = rental.inventory_id AND rental.return_date IS NULL
WHERE
    film.title = 'Academy Dinosaur'
    AND store.store_id = 1
HAVING availability = 'Available';
