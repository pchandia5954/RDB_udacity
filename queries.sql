/* Query 1
Best month for each store in 2005 */
SELECT DATE_PART('month', r.rental_date) AS rental_m,
DATE_PART('year', r.rental_date) AS rental_y,sto.store_id AS store_id,
COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN staff sta
ON r.staff_id = sta.staff_id
JOIN store sto
ON sta.store_id = sto.store_id
GROUP BY 3, 1, 2
ORDER BY 4 DESC
LIMIT 8;

/* Query 2
Most common genres of films rented */
SELECT f.title, c.name category,
COUNT(*)
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN film f
ON fc.film_id = f.film_id
JOIN inventory i
ON i.film_id = f.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1, 2
ORDER BY 2, 1;

/* Query 3
Top 5 best customers ever */
WITH t1 AS (SELECT *, first_name || ' ' || last_name AS customer_name FROM customer)
SELECT customer_name, email, sum(amount) as total_spend
FROM t1
JOIN payment
USING(customer_id)
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 5;

/* Query 4
How is the distribution of lenght by genre */
WITH t2 AS(SELECT film_id, title, rental_duration, NTILE(4) OVER (ORDER BY rental_duration) AS quartile
FROM film f
ORDER BY film_id),
categories AS (SELECT category_id, name
FROM category as C
WHERE name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))
SELECT c.name, rq.quartile, COUNT(rq.film_id)
FROM categories AS c
JOIN film_category AS fc
USING(category_id)
JOIN t2 AS rq
USING(film_id)
GROUP BY 1, 2
ORDER BY 1, 2;
