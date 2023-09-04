-----Question Set 1 - Easy

Q1: Who is the senior most employee based on job title?

	Select * from employee	
	order by levels desc
	Limit 1
	
Q2: Which countries have the most Invoices?
    
	SELECT billing_country, count(billing_country) As Most_invoices FROM invoice
	group by billing_country
	Order by Most_invoices Desc 
	
Q3: What are top 3 values of total invoice?
 
    SELECT max(total) as top_3 FROM invoice
	Group By total
	Order by top_3 desc
	limit 3

Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals
 
    Select billing_city , sum(total) as Best_customers from invoice 
	Group by billing_city
	order by Best_customers Desc 
	Limit 1
	
	
Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money

	
   	select cu.customer_id,cu.first_name,cu.last_name, Sum(iu.total) As Total_Spends
	from customer As cu 
	Join invoice as iu
	on cu.customer_id = iu.customer_id
	Group by cu.customer_id
	Order BY Total_Spends DESC
	Limit 1
	
----- Question Set 2 - Moderate

Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A
    
	Select Distinct cu.email,cu.first_name,cu.last_name
	from customer As cu
	Join invoice as iv on cu.customer_id = iv.customer_id
	Join invoice_line as il on iv.invoice_id = il.invoice_id
	Where 
	track_id in(
		select tk.track_id from Track as tk
	Join genre as gn on tk.ganre_id = gn.genre_id
		Where gn.name Like 'Rock'
		)
	Order by cu.email
	
SELECT DISTINCT
    cu.email,
    cu.first_name,
    cu.last_name
FROM
    customer AS cu
JOIN
    invoice AS iv ON cu.customer_id = iv.customer_id
JOIN
    invoice_line AS il ON iv.invoice_id = il.invoice_id
WHERE
    track_id IN (
        SELECT tr.track_id
        FROM Track AS tr
        JOIN genre AS gn ON tr.genre_id = gn.genre_id
        WHERE gn.name LIKE 'Rock'
    )
ORDER BY
    cu.email;
	
---METHOD2---

         SELECT DISTINCT email AS Email,first_name AS FirstName, last_name AS LastName, genre.name AS Name
         FROM customer
         JOIN invoice ON invoice.customer_id = customer.customer_id
         JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
         JOIN track ON track.track_id = invoice_line.track_id
         JOIN genre ON genre.genre_id = track.genre_id
         WHERE genre.name LIKE 'Rock'
         ORDER BY email;
		 
Q2: Lets invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands 


   	SELECT DISTINCT Artist.Name, COUNT(Artist.artist_id)  AS Number_of_songs
    FROM Artist
    JOIN Album ON Album.artist_id = Artist.artist_id
    JOIN Track ON Track.album_id = Album.album_id
    JOIN Genre ON Genre.genre_id = Track.genre_id
    WHERE Genre.name = 'Rock'
    GROUP BY  Artist.Name
    ORDER BY Number_of_songs Desc
    LIMIT 10;
	
	
Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
    
	
	Select track.Name ,milliseconds 
	From track
	Where milliseconds > (Select Avg(milliseconds) From track)
	Order by milliseconds Desc
	
	
-----Question Set 3 - Advance

Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent


     With best_selling_artist AS( 
	 Select artist.artist_id As artist_id, artist.name As artist_name,
	 Sum(invoice_line.Unit_price*invoice_line.Quantity) As total_Sales
     From invoice_line
	 Join track On track.track_id = invoice_line.track_id
	 join album On album.album_id = track.album_id
     Join artist On artist.artist_id = album.artist_id
		 Group by 1
		 order By 3 Desc 
		 Limit 1
		 )
		 SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price*il.quantity) AS amount_spent
         FROM invoice i
         JOIN customer c ON c.customer_id = i.customer_id
         JOIN invoice_line il ON il.invoice_id = i.invoice_id
		 JOIN track t ON t.track_id = il.track_id
         JOIN album alb ON alb.album_id = t.album_id
		 JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
		 GROUP BY 1,2,3,4
		 ORDER BY 5 DESC;


Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres



   WITH popular_genre AS 
(
    SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
    FROM invoice_line 
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1


Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount


    With Cte As (
	Select customer.customer_id,first_name,last_name,billing_country,Sum(total) As total_Spending,
	Row_Number() Over(Partition By Billing_country Order By Sum(Total) Desc) As Row_NO
	From invoice
	Join customer 
	On customer.customer_id = invoice.customer_id
	Group By 1,2,3,4
	Order By 4 Asc,5 Desc )
	Select * From Cte Where Row_No >= 1
		
	
		 














