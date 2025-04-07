use pizzahut;
-- Q1) Retrieve the total number of orders placed.
SELECT 
    COUNT(order_id)
FROM
    orders AS total_orders_placed;




-- Q2) Calculate the total revenue generated from pizza sales.
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
    -- Q3) Identify the highest-priced pizza
    
    SELECT 
    pizza_types.name, pizzas.price AS highest_priced_pizza
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;




-- Q4) Identify the most common pizza size ordered.
SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS order_count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;





-- Q5) List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.name,
    SUM(order_details.quantity) AS Ordered_Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Ordered_Quantity DESC
LIMIT 5;




-- Q6) Join the necessary tables to find the total quantity of each pizza category ordered.

 
SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS Ordered_Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY Ordered_Quantity DESC;



-- Q7) Determine the distribution of orders by hour of the day.
SELECT 
    HOUR(time) AS hour, COUNT(order_id) AS Orders
FROM
    orders
GROUP BY hour;




-- Q8) Join relevant tables to find the category-wise distribution of pizzas.
SELECT 
    category, COUNT(pizza_type_id) as Count
FROM
    pizza_types
GROUP BY category;




-- Q9) Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT 
    ROUND(AVG(quantity), 2) AS Avg_pizzas_ordered_per_day
FROM
    (SELECT 
        orders.date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.date) AS order_quantity;
    
    
    
    
    -- Q10)  Determine the top 3 most ordered pizza types based on revenue.
   SELECT 
    pizza_types.name AS Top_3_most_ordered_pizzas,
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY Revenue DESC
LIMIT 3;




-- Q11) Calculate the percentage contribution of each pizza type to total revenue.

 SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON order_details.pizza_id = pizzas.pizza_id) * 100,
            2) AS REVENUE_Percentage
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY REVENUE_Percentage DESC;
    



-- Q12) Analyze the cumulative revenue generated over time.
Select date , sum(Revenue) over (order by date) as Cumulative_Revenue
From

(SELECT 
    orders.date,
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS Revenue
FROM
    order_details
        JOIN
    pizzas ON order_details.pizza_id = pizzas.pizza_id
        JOIN
    orders ON orders.order_id = order_details.order_id
GROUP BY orders.date) as Sales;




-- Q13) Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select name,revenue, category
from
(select category, name, revenue,
rank() over( partition by category order by revenue desc) as rn
From

( SELECT 
    pizza_types.category,
    pizza_types.name,
    (SUM(order_details.quantity * pizzas.price)) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category , pizza_types.name ) as a ) as b

where rn <= 3;
