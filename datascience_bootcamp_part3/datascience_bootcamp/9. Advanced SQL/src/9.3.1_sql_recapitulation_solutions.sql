USE Chinook;


-- 1. How many artists are in the database?
SELECT 
    COUNT(artistid)
FROM
    artist;


-- 2. Create an alphabetised list of the artists
SELECT 
    name
FROM
    artist
ORDER BY name;


-- 3. Show only the customers from Germany.
SELECT 
    *
FROM
    customer
WHERE
    country = 'Germany';
    
    
-- 4. Get the full name, customer ID, and country of customers not in the US?
SELECT 
	CONCAT(firstname, " ", lastname) as FullName,
    customerid, 
    country
FROM
    customer
WHERE
    NOT country = 'USA';


-- 5. Find the track with the longest duration.
SELECT
	trackid,
    name, 
    MAX(milliseconds)
FROM
    track
GROUP BY trackid, Name;


-- 6. Which tracks have 'love' in their title?
SELECT DISTINCT
    name
FROM
    track
WHERE
    name LIKE '%love%';


-- 7. What is the difference in days between the earliest and latest invoice?
SELECT 
    DATEDIFF(MAX(invoicedate), MIN(invoicedate)) AS Days
FROM
    invoice;
   
   
-- 8. Which genres have more than 100 tracks?
SELECT 
    g.name AS Genre, COUNT(*) AS TrackCount
FROM
    track t
        JOIN
    genre g ON t.GenreId = g.GenreId
GROUP BY g.name
HAVING COUNT(*) > 100;


-- 9. Create a table showing countries alongside how many invoices there are per country
SELECT 
    billingcountry AS Country, 
    COUNT(invoiceid) AS InvoiceCount
FROM
    iNVOICE
GROUP BY billingcountry
ORDER BY COUNT(invoiceid) DESC;


-- 10. Find the name of the employee who has served the most customers.
SELECT 
    CONCAT(e.firstName, " ", e.lastName) AS Employee,
    COUNT(c.customerid) AS CustomerCount
FROM
    employee e
        LEFT JOIN
    customer c ON e.employeeId = c.supportrepid
GROUP BY employee
ORDER BY customercount DESC
LIMIT 1;


-- 11. Which customers have a first name that starts with 'A' and is 5 letters long?
SELECT 
    customerid, firstname
FROM
    customer
WHERE
    firstname LIKE 'A____';


-- 12. Find the total number of tracks in each playlist.
SELECT 
    p.name, 
    COUNT(*) AS TrackCount
FROM
    playlist p
        JOIN
    playlisttrack pt USING (playlistid)
GROUP BY p.playlistid;


-- 13. Find the artist that appears in the most playlists.
SELECT 
    a.name, 
    COUNT(DISTINCT pt.playlistid) AS PlaylistCount
FROM
    artist a
        JOIN
    album al USING (artistid)
        JOIN
    track t USING (albumid)
        JOIN
    playlisttrack pt USING (trackid)
GROUP BY a.artistid
ORDER BY playlistcount DESC
LIMIT 1;


-- 14. Find the genre with the most tracks.
SELECT 
    g.name, 
    COUNT(*) AS TrackCount
FROM
    genre g
        JOIN
    track t USING (genreId)
GROUP BY g.genreid
ORDER BY trackcount DESC
LIMIT 1;


-- 15. Which tracks have a composer whose name ends with 'Smith'?
SELECT 
    trackid, 
    name, 
    composer
FROM
    track
WHERE
    composer LIKE '%Smith';


-- 16. Which artists have albums in the 'Rock' or 'Blues' genres?
SELECT DISTINCT
    a.name
FROM
    artist a
        JOIN
    album al USING (artistid)
        JOIN
    track t USING (albumid)
        JOIN
    genre g USING (genreid)
WHERE
    g.Name IN ('Rock' , 'Blues');
    
    
-- 17. Which tracks are in the 'Rock' or 'Blues' genre and have a name that is exactly 5 characters long?
SELECT 
    trackid, 
    t.Name
FROM
    track t
        INNER JOIN
    genre g USING (genreid)
WHERE
    g.Name IN ('Rock' , 'Blues')
        AND t.Name LIKE '_____';


-- 18. Classify customers as 'Local' if they are from Canada, 'Nearby' if they are from the USA, and 'International' otherwise.
SELECT 
    customerid,
    firstname,
    lastname,
    CASE
        WHEN country LIKE 'Canada' THEN 'Local'
        WHEN country LIKE 'USA' THEN 'Nearby'
        ELSE 'International'
    END AS CustomerType
FROM
    customer;


-- 19. Find the total invoice amount for each customer.
SELECT 
    CONCAT(c.firstname, " ", c.lastname) AS Customer,
    SUM(i.total) AS TotalInvoiceAmount
FROM
    customer c
        JOIN
    invoice i USING (customerid)
GROUP BY c.customerid;


-- 20. Find the customer who has spent the most on music.
SELECT 
    CONCAT(c.firstName, " ", c.lastName) AS Customer,
    SUM(i.total) AS TotalSpent
FROM
    customer c
        JOIN
    invoice i USING (customerid)
GROUP BY c.customerid
ORDER BY TotalSpent DESC
LIMIT 1;


-- 21. Find the most popular album, and the associated artist.
SELECT 
	a.name,
    al.title, 
    COUNT(*) AS PurchaseCount
FROM
	artist a
		JOIN
    album al USING(artistid)
        JOIN
    track t USING(albumid)
        JOIN
    invoiceline il USING (trackid)
GROUP BY a.name, al.albumid
ORDER BY PurchaseCount DESC
LIMIT 1;


-- 22. How many more songs were sold from each media type?
SELECT 
	mt.name AS MediaType,
    COUNT(t.trackid) AS AmountOfTracks
FROM
    track t
        JOIN
    mediatype mt USING (mediatypeid)
GROUP BY mediatypeid;


-- 23. Find the most popular track of 2023.
SELECT 
    t.Name, COUNT(*) AS PurchaseCount
FROM
    Track t
        JOIN
    InvoiceLine il ON t.TrackId = il.TrackId
        JOIN
    Invoice i ON il.InvoiceId = i.InvoiceId
WHERE
    YEAR(i.InvoiceDate) = 2023
GROUP BY t.TrackId
ORDER BY PurchaseCount DESC
LIMIT 1;


-- 24. Find the total sales per genre, only include genres with sales between 100 and 500.
SELECT 
    g.Name, 
    SUM(i.Total) AS TotalSales
FROM
    Genre g
        JOIN
    Track t ON g.GenreId = t.GenreId
        JOIN
    InvoiceLine il ON t.TrackId = il.TrackId
        JOIN
    Invoice i ON il.InvoiceId = i.InvoiceId
GROUP BY g.GenreId
HAVING TotalSales BETWEEN 100 AND 500;


-- 25. Find the total number of tracks sold per artist. 
-- Add an extra column categorising the artists into 'High', 'Medium', 'Low' based on the number of tracks sold.
-- High is more than 100, Low is less than 50.
SELECT 
    a.Name,
    COUNT(*) AS TrackCount,
    CASE
        WHEN COUNT(*) > 100 THEN 'High'
        WHEN COUNT(*) >= 50 THEN 'Medium'
        ELSE 'Low'
    END AS Category
FROM
    artist a
        JOIN
    album al USING (artistid)
        JOIN
    Track t USING (albumid)
        JOIN
    invoiceline il USING (trackid)
GROUP BY a.artistid;